Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXBTGph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXBTGph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXBTGpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:45:36 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:34187 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791AbXBTGpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:45:36 -0500
Message-ID: <45DA9918.7000407@drzeus.cx>
Date: Tue, 20 Feb 2007 07:45:44 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] drivers/mmc/Kconfig source drivers/mmc/card/Kconfig
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000751.GE13958@stusta.de>
In-Reply-To: <20070220000751.GE13958@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>> ...
>> Changes since 2.6.20-mm1:
>> ...
>>  git-mmc.patch
>> ...
>>  git trees
>> ...
> 
>  
> The MMC_BLOCK option was accidentally lost.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

Thanks. I wonder how that happened.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
