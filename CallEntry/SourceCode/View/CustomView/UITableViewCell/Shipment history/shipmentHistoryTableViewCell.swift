//
//  shipmentHistoryTableViewCell.swift
//  CallEntry
//
//  Created by HMSPL on 15/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class shipmentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblShipmentNo: UILabel!
    @IBOutlet weak var lblShipmentDate: UILabel!
    @IBOutlet weak var lblOrigin: UILabel!
    
    @IBOutlet weak var lblDestination: UILabel!
    
    @IBOutlet weak var lblETD: UILabel!
    
    @IBOutlet weak var lblETA: UILabel!
    
    @IBOutlet weak var lblBookingPersonName: UILabel!
    
    @IBOutlet weak var lblUpdate: UILabel!
    
    @IBOutlet weak var imgSegment: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellDataWithLastShipment(shipment: Lastshipment) {
       
        lblShipmentNo.text = "Shipment #" + shipment.shipmentno
        lblShipmentDate.text = shipment.date
        lblOrigin.text = shipment.origin
        lblDestination.text = shipment.destination
        imgSegment.image = UIImage.init(named: shipment.segment == "Air" ? "flight" : shipment.segment == "FCL" ? "ship" : "Truck")
        lblETA.text = shipment.eta
        lblETD.text = shipment.etd
        lblBookingPersonName.text = shipment.bookingperson
        lblUpdate.text = shipment.update
    }
    
    func configureCellDataWithHistory(shipment: History) {
        
        lblShipmentNo.text = "Shipment " + shipment.shipmentno
        lblShipmentDate.text = shipment.date
        lblOrigin.text = shipment.origin
        lblDestination.text = shipment.destination
        switch shipment.segment.uppercased()
        {
        case "AIR":
            imgSegment.image = UIImage(named: "flight")!
        case "FCL":
            imgSegment.image = UIImage(named: "ship")!
        case "LCL":
            imgSegment.image = UIImage(named: "truck")!
        default:
            break
        }
        lblETA.text = shipment.eta
        lblETD.text = shipment.etd
        lblBookingPersonName.text = shipment.bookingperson
        lblUpdate.text = shipment.update
    }
}
