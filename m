Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbZLOTru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbZLOTru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760938AbZLOTrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:47:48 -0500
Received: from kroah.org ([198.145.64.141]:43516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760901AbZLOTrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:47:46 -0500
Date: Tue, 15 Dec 2009 11:47:32 -0800
From: Greg KH <gregkh@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] firmware for RealTek RTL8192E wireless device.
Message-ID: <20091215194732.GA13176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been in the staging tree for a while now, and people
keep asking me for a copy of the firmware.  SuSE has been shipping it
for a while in their copy of the linux-firmware package, so I figured it
was time to add it to the main linux-firmware repo now, sorry
for the delay.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/firmware.git/

thanks,

greg k-h

------------

 RTL8192E/boot.img |  Bin 0 -> 344 bytes
 RTL8192E/data.img |  Bin 0 -> 848 bytes
 RTL8192E/main.img |  Bin 0 -> 42944 bytes
 WHENCE            |   10 ++++++++++
 4 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 RTL8192E/boot.img
 create mode 100644 RTL8192E/data.img
 create mode 100644 RTL8192E/main.img

---------------

Greg Kroah-Hartman (1):
      Add RealTek RTL8192E firmware

