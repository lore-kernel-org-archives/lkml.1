Return-Path: <linux-kernel-owner+w=401wt.eu-S1422853AbXBANGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422853AbXBANGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXBANGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:06:40 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49840 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422853AbXBANGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:06:39 -0500
Message-ID: <45C1E5D9.8060007@drzeus.cx>
Date: Thu, 01 Feb 2007 14:06:33 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Kobajashi Zaghi <kobajashi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2 GB SD card problem vs. 2.6.20-rc7 (FAT: Filesystem panic (dev
 sdc1))
References: <64b272cb0702010500k4e5d6576kb077991bb03afd0e@mail.gmail.com>
In-Reply-To: <64b272cb0702010500k4e5d6576kb077991bb03afd0e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kobajashi Zaghi wrote:
> Hi Pierre!
> 
> I have two 2GB capacity SD card (Kingston, noname). When i put either
> of them to a card reader, kernel recognize, but "see" only 1GB
> capacity, and when i try to access, FAT filesystem paniced.
> 

Your device is not a MMC/SD bridge, so I'm the wrong person to contact
for this. You should contact whoever is in charge of USB storage devices
(which is what you've got).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
