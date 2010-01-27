Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143Ab0A0V7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0A0V7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102Ab0A0V7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:59:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab0A0V7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:59:22 -0500
Message-ID: <4B60B721.1020908@redhat.com>
Date: Wed, 27 Jan 2010 19:58:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       dean <dean@sensoray.com>
Subject: [PULL] firmware for Sensoray s2255 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c024a251e1dd1a39de610bbdc2af65b36e42637d:
  David Woodhouse (1):
        Merge from fixed from-kernel tree to fix Matrox firmware binaries

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

Mauro Carvalho Chehab (1):
      Firmware for Sensoray s2255 webcam drivers

 WHENCE       |   13 +++++++++++++
 f2255usb.bin |  Bin 0 -> 180760 bytes
 2 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 f2255usb.bin

