Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbZCUFw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbZCUFw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761705AbZCUFuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:50:54 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:53224 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760920AbZCUFuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:50:51 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: LKML <linux-kernel@vger.kernel.org>
Subject: Bluetooth Q?
Date: Sat, 21 Mar 2009 01:50:45 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc8; KDE/4.2.0; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903210150.46294.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Where can I find the status of support for a usb-bt module that answers to 
this:

Mar 21 00:55:29 coyote kernel: [97026.014221] usb 2-5.1: new full speed USB device using ohci_hcd and address 8
Mar 21 00:55:29 coyote kernel: [97026.103223] usb 2-5.1: New USB device found, idVendor=0e5e, idProduct=6622
Mar 21 00:55:29 coyote kernel: [97026.103226] usb 2-5.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Mar 21 00:55:29 coyote kernel: [97026.103308] usb 2-5.1: configuration #1 chosen from 1 choice
Mar 21 00:55:29 coyote bluetoothd[2581]: HCI dev 0 registered
Mar 21 00:55:29 coyote bluetoothd[2581]: HCI dev 0 up
Mar 21 00:55:29 coyote bluetoothd[2581]: Starting security manager 0
Mar 21 00:55:30 coyote bluetoothd[2581]: Registered interface org.bluez.NetworkPeer on path /org/bluez/2581/hci0
Mar 21 00:55:30 coyote bluetoothd[2581]: Registered interface org.bluez.NetworkHub on path /org/bluez/2581/hci0
Mar 21 00:55:30 coyote bluetoothd[2581]: Registered interface org.bluez.NetworkRouter on path /org/bluez/2581/hci0
Mar 21 00:55:30 coyote bluetoothd[2581]: Registered interface org.bluez.SerialProxyManager on path /org/bluez/2581/hci0
Mar 21 00:55:30 coyote bluetoothd[2581]: Registered interface org.bluez.Service on path /org/bluez/2581/hci0
Mar 21 00:55:30 coyote bluetoothd[2581]: Failed to listen on control channel
Mar 21 00:55:30 coyote bluetoothd[2581]: Adapter /org/bluez/2581/hci0 has been enabled

But this device is nowhere to be found in the /dev listings?

Good links appreciated.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
static buildup

