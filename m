Return-Path: <linux-kernel-owner+w=401wt.eu-S1031228AbXD1Txl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031228AbXD1Txl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031225AbXD1Txk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:53:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:56384 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1031203AbXD1Txi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:53:38 -0400
X-Authenticated: #4011369
X-Provags-ID: V01U2FsdGVkX19dwbB+1G9d5ash12eaOZqOJRnZxuDMTE80ZoBigz
	XDeyQZTPPzfoiP
Subject: Probable PCIE prob
From: Syren Baran <sbaran@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 21:53:37 +0200
Message-Id: <1177790017.3649.23.camel@excalibur>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i got a problem with the combination of an Asrock AM2NF4G-SATA2
mainboard with a Radeon X1900 (chip 1002,724b) graphics
card. /i386/pci/mmconfig.c reports a buggy bios (e0000000 is not
E820-reserved). System crashes only happen when viewing films (neither
xine nor mplayer run with root privileges) and independent of video
drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
before crashing. Anybody got a clue?

Thanks,
Syren

