Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbXA0NII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbXA0NII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 08:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXA0NII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 08:08:08 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41167 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbXA0NIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 08:08:07 -0500
Message-ID: <45BB4EB7.9020003@drzeus.cx>
Date: Sat, 27 Jan 2007 14:08:07 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: linux@youmustbejoking.demon.co.uk, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH 2.6.20-rc2] Add a quirk to allow ENE PCI SD card readers
 to work again
References: <4E9DA5E8EB%linux@youmustbejoking.demon.co.uk> <4597A791.60007@drzeus.cx> <4E9DE7C297%linux@youmustbejoking.demon.co.uk> <4E9DF295D4%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4E9DF295D4%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Salt wrote:
> Add a quirk to allow ENE PCI SD card readers to work again
> 

Ok, I think we can consider testing over. I will apply this upstream
with the original host mask (as we didn't get any reports of it helping
on other ene controllers).

Thanks again for doing the legwork on this.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
