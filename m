Return-Path: <linux-kernel-owner+w=401wt.eu-S933865AbXCVMDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865AbXCVMDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXCVMDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:03:13 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56325 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865AbXCVMDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:03:13 -0400
Message-ID: <460270B8.3000006@drzeus.cx>
Date: Thu, 22 Mar 2007 13:04:08 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4: mmc fails to work, then oopses
References: <20070322113742.GA7198@elf.ucw.cz>
In-Reply-To: <20070322113742.GA7198@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> (Machine was suspended/resumed before this).
> 
> mount /dev/mmc1 /mnt
> 

Driver? Reproducable? Vanilla git kernel?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
