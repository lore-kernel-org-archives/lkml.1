Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040Ab0A2Wp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0A2Wp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953Ab0A2Wpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:45:55 -0500
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:46437 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0A2Wpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:45:54 -0500
X-MXL-Hash: 4b6365227aa3aa32-d7cf3709ed68edaff1f80d1fe0cdf7db97db06ae
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 2.6.33 4/4] net: Add PCI vendor and device ids for Micrel KSZ8841/2 PCI devices
Date: Fri, 29 Jan 2010 14:45:49 -0800
Message-ID: <14385191E87B904DBD836449AA30269D021A50@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 4/4] net: Add PCI vendor and device ids for Micrel KSZ8841/2 PCI devices
Thread-Index: AcqhNM32DbPzQ/cQRkqDm0XYLQDHsQ==
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Dave Miller" <davem@davemloft.net>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jan 2010 22:45:50.0152 (UTC) FILETIME=[CE17D480:01CAA134]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=FnxsLPrOMwkA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=6AgLA8PWXsePVqb5X-wA:9 a=MPDEvxarRxArst]
X-AnalysisOut: [GOM8Mtr5NtgZAA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristram Ha <Tristram.Ha@micrel.com>

Add PCI vendor and device ids for Micrel KSZ8841/2 PCI devices.

Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
---
This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.

--- linux-2.6.33-rc5.old/include/linux/pci_ids.h	2010-01-21 15:31:35.000000000 -0800
+++ linux-2.6.33-rc5.new/include/linux/pci_ids.h	2010-01-29 10:38:53.000000000 -0800
@@ -2199,6 +2199,12 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_MICREL_KS		0x16c6
+#define PCI_DEVICE_ID_MICREL_KS8692	0x8692
+#define PCI_DEVICE_ID_MICREL_KS8695	0x8695
+#define PCI_DEVICE_ID_MICREL_KS8841	0x8841
+#define PCI_DEVICE_ID_MICREL_KS8842	0x8842
+
 #define PCI_VENDOR_ID_CENATEK		0x16CA
 #define PCI_DEVICE_ID_CENATEK_IDE	0x0001
 
