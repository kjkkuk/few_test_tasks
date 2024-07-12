require_relative 'lib/gps_data_processor'

filepath = '/home/dyakutovich/old/few_test_tasks/task_4/gpstrace_node1.json'
output_path = 'processed_route.json'

processor = GPSDataProcessor.new(filepath)
processor.load_data
processor.filter_data
processor.smooth_data
processor.cluster_data
processor.save_route(output_path)
