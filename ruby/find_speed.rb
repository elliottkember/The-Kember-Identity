# Very simple benchmarking; returns hashes/s for one cpu.
# Note that you achieve a nearly n-times faster result if you start the script
# n-times (with different status files), where n is the number of your cpus.
class FindSpeed

  def initialize( item_count )
    @item_count = item_count
    @start_time = nil
  end

  def start
    @start_time = Time.new
  end

  # Returns items per second
  def stop
    return -1 unless @start_time
    distance = Time.new.to_f - @start_time.to_f
    speed = @item_count.to_f / distance
    speed.to_i
  end

end
