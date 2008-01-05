Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYAEPu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYAEPu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYAEPtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:49:23 -0500
Received: from [212.12.190.185] ([212.12.190.185]:52994 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756220AbYAEPtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:49:19 -0500
Message-Id: <200801051546.SAA08937@raad.intranet>
From: Al Boldi <a1426z@gawab.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
Date: Sat, 5 Jan 2008 18:40:38 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reorganize USB Kconfig Menu, and move USB_GADGET out into the Device Driver
Menu.  This helps the USB Kconfig Menu to be more logical/usable.

Patchset against 2.6.23

 arch/arm/Kconfig            |    2 ++
 arch/v850/Kconfig           |    2 ++
 drivers/Kconfig             |    2 ++
 drivers/usb/Kconfig         |   26 ++++++++++++--------------
 drivers/usb/atm/Kconfig     |   12 ++++++------
 drivers/usb/class/Kconfig   |    6 +++++-
 drivers/usb/core/Kconfig    |    7 +++++++
 drivers/usb/gadget/Kconfig  |   10 +++++-----
 drivers/usb/host/Kconfig    |    3 ++-
 drivers/usb/image/Kconfig   |    7 ++++++-
 drivers/usb/misc/Kconfig    |    6 +++++-
 drivers/usb/serial/Kconfig  |   10 ++++------
 drivers/usb/storage/Kconfig |   25 ++++++++++++++-----------
 13 files changed, 72 insertions(+), 46 deletions(-)



Thanks!

--
Al

