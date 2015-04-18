-----------------------------
-- User Editable Variables --
-----------------------------

modem_side = "front"
monitor_side = "back"
modem_channel = 101
refresh_time = 2
monitor_scale = 0.5
show_percentage = false
show_label = true

bars_num = 2
label = {
  "MFSU 1",
  "MFSU 2"
}


--------------------------------------
-- DO NOT MODIFY ANYTHING FROM HERE --
--------------------------------------

-- set peripherals
monitor = peripheral.wrap(monitor_side)
modem = peripheral.wrap(modem_side)
modem.open(modem_channel)
monitor.setTextScale(monitor_scale)

-- initalize monitor
monitor.setBackgroundColor(colors.black)
monitor.clear()

data_table = {}

-- gettable: get data table from modem
function gettable()
  local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
  data_table = textutils.unserialize(message)
end

-- color function
--[[function getcolor(val)
  if val < 0.15 then
    return colors.red
  elseif val < 0.75 then
    return colors.orange
  elseif val < 1.5 then
    return colors.green
  else
    return colors.magenta
  end
end
--]]


function drawGraph()
  width, height = monitor.getSize()
  local percentage_line = 0

  -- calc bar_width
  bar_width = math.floor((width-bars_num+1) / bars_num)
  print("1:",bar_width)

  if bars_num == 0 then
    return
  end

  -- draw function
  for v=0,bars_num-1,1 do
    local bar_begin = (v * bar_width) + v + 1
    local bar_end = bar_begin + bar_width - 1
    print("2:",bar_begin)
    print("3:",bar_end)

    percent = data_table[v+1] / 40000000
    percentage = height * percent

    y = height - math.floor(percentage + 0.5)

    --[[ percentage_draw
    if percentage_line == 1 then
      local round_percent = math.floor((percent*100) + 0.5)
      local text = round_percent.."%"
      local bar_pos = bar_begin + math.floor((bar_width-string.len(text))/2)
      monitor.setCursorPos(bar_pos,1)
      monitor.setBackgroundColor(colors.black)
      monitor.settextColor(colors.white)

      monitor.write(text)
    end
    --]]

    -- draw [i=draw height; j=draw width]
    for i=1,height do
      for j=bar_begin,bar_end do
        local c
        if i > y then
          c = colors.green
        else
          c = colors.black
        end
        monitor.setBackgroundColor(c)
        monitor.setCursorPos(j, i)
        monitor.write(" ")
      end
    end

    -- label_draw
    if show_label == true then
      local text = label[v+1]
      local bar_pos = bar_begin + math.floor((bar_width-string.len(text))/2)
      monitor.setCursorPos(bar_pos,height)
      monitor.setTextColor(colors.white)
      monitor.write(text)
    end

    -- v_how_many_bars
    if (v+1) >= bars_num then
      return
    end
  end
end

-- while-loop
while true do
  getvalue()
  drawGraph()
  sleep(refresh_time)
end
