Return-Path: <linux-kernel-owner+w=401wt.eu-S1750996AbXBMFrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbXBMFrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXBMFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:47:41 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49980 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXBMFrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:47:40 -0500
Message-ID: <45D150FD.8080901@drzeus.cx>
Date: Tue, 13 Feb 2007 06:47:41 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Sascha Sommer <saschasommer@freenet.de>
CC: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rmk+mmc@arm.linux.org.uk, Elladan <elladan@eskimo.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
References: <200701070032.27234.saschasommer@freenet.de> <45A0C3A7.2040506@gmail.com> <200702112122.38440.saschasommer@freenet.de>
In-Reply-To: <200702112122.38440.saschasommer@freenet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Sommer wrote:
> I still consider this driver experimental, but without documentation this is 
> probably not going to change anytime soon.
> The question is now what I should do with the driver?
> Is it worth to be included in the kernel? If yes where and against what 
> kernelversion should I send the patch?
>
>   

That's up to you. The most important thing for any part of the kernel is
that it must have a maintainer. So if you are ready to keep the driver
up to date and handle the support requests that show, then you should
really submit it.

Patches should always be sent against the current version of the kernel
(i.e. git HEAD). Usually the latest packaged release will also do.

(Note that I haven't had time to review your latest version of the driver)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

