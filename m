Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbXBCVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbXBCVq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 16:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXBCVq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 16:46:59 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56898 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXBCVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 16:46:59 -0500
Message-ID: <45C502C6.1090304@drzeus.cx>
Date: Sat, 03 Feb 2007 22:46:46 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx
Subject: Re: [Sdhci-devel] x60: mmc card reader problem
References: <20070203002443.GA3031@elf.ucw.cz>
In-Reply-To: <20070203002443.GA3031@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> ...it wants me to report:
> 
> 
> ...yes, I yanked the card when I seen "unknown partition table".
> 
> (This is how it looks on debug console; it captured the dumps, too:)
> 

Error 1 is timeout, which can be caused by many things. Have you tried
with several cards? And is it repeatable?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
