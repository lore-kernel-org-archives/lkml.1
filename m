Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab0BSE1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 23:27:24 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37853 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183Ab0BSE1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 23:27:22 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 23:27:22 EST
Message-ID: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com>
From: "masa-korg" <masa-korg@dsn.okisemi.com>
To: <linux-kernel@vger.kernel.org>
Cc: <andrew.chih.howe.khor@intel.com>, <joel.clark@intel.com>
Subject: [PATCH]Add new device drivers for Topcliff
Date: Fri, 19 Feb 2010 13:03:44 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Topcliff is a chip that has many peripherals.
The chip has UART, I2C, SPI, IEEE1588, CAN, Packet HUB, SATA, USB host, USB
device, SDIO, Gigabit Ethernet, GPIO and DMA.

I developed the device drivers for Linux.

Please refer to our WEB site in Sourceforge.net.
http://sourceforge.net/projects/generalembedded/files/
"All Files" -> "Downloads" -> "Beta2"

Following drivers are available now.

[Device name} [File name]
Common patch common_patch.tar.bz2
CAN  can.tar.bz2
DMA  dma.tar.bz2
GbE  gbe.tar.bz2
GPIO  gpio.tar.bz2
I2C  i2c.tar.bz2
IEEE1588 ieee1588.tar.bz2
Packet HUB pcieqos.tar.bz2
SPI  spi.tar.bz2
UART  uart.tar.bz2
USB Device usbdev.tar.bz2

Best regards,


