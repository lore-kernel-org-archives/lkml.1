Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0CBPUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:20:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0CBPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:20:12 -0500
Message-ID: <4B8D2CA8.80505@infradead.org>
Date: Tue, 02 Mar 2010 12:20:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: david woodhouse <dwmw2@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL - RESEND] Firmwares for Sensoray s2255 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c024a251e1dd1a39de610bbdc2af65b36e42637d:
  David Woodhouse (1):
        Merge from fixed from-kernel tree to fix Matrox firmware binaries

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Mauro Carvalho Chehab (2):
      Firmware for Sensoray s2255 webcam drivers
      Additional firmwares for Sensoray s2255 webcam drivers

 WHENCE          |   14 ++++++++++++++
 f2255usb.bin    |  Bin 0 -> 180760 bytes
 s2250.fw        |  Bin 0 -> 9508 bytes
 s2250_loader.fw |  Bin 0 -> 1092 bytes
 4 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 f2255usb.bin
 create mode 100644 s2250.fw
 create mode 100644 s2250_loader.fw
