Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYHCVkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYHCVkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYHCVkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:40:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56314 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbYHCVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:40:34 -0400
Date: Sun, 3 Aug 2008 17:38:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: full list of unused CONFIGs under drivers/
Message-ID: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  amazingly, the full list of unused CONFIG variables under drivers/
now fits on a single page.  whoo hoo.  apparently, incessant nagging
gets results.  :-)

===== FB_N411
drivers/video/Kconfig:708:config FB_N411
===== MTD_NAND_ATMEL_ECC_SOFT
drivers/mtd/nand/Kconfig:313:config MTD_NAND_ATMEL_ECC_SOFT
===== SCSI_QLOGIC_FC_FIRMWARE
drivers/scsi/Kconfig:1328:config SCSI_QLOGIC_FC_FIRMWARE
===== SERIAL_CPM_SCC1
drivers/serial/Kconfig:1138:config SERIAL_CPM_SCC1
===== SERIAL_CPM_SCC2
drivers/serial/Kconfig:1144:config SERIAL_CPM_SCC2
===== SERIAL_CPM_SCC3
drivers/serial/Kconfig:1150:config SERIAL_CPM_SCC3
===== SERIAL_CPM_SCC4
drivers/serial/Kconfig:1156:config SERIAL_CPM_SCC4
===== SERIAL_CPM_SMC1
drivers/serial/Kconfig:1162:config SERIAL_CPM_SMC1
===== SERIAL_CPM_SMC2
drivers/serial/Kconfig:1168:config SERIAL_CPM_SMC2
===== USB_OHCI_HCD_PCI
drivers/usb/host/Kconfig:186:config USB_OHCI_HCD_PCI

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
