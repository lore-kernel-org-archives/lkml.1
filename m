Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXCFFqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXCFFqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965784AbXCFFqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:46:25 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58029 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933958AbXCFFqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:46:24 -0500
Message-ID: <45ED0074.5010606@drzeus.cx>
Date: Tue, 06 Mar 2007 06:47:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>, sdhci-devel@list.drzeus.cx,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>	<20070305015031.GF3441@stusta.de>	<45EB9DC6.8010403@rtr.ca>	<45EB9E72.6040107@rtr.ca>	<45EBAC73.7010600@drzeus.cx>	<45EC2851.7020905@rtr.ca>	<45EC351B.2020206@rtr.ca> <20070305201707.8d8a092e.akpm@linux-foundation.org>
In-Reply-To: <20070305201707.8d8a092e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> (I'm also inclined to drop the darned mmc tree - am getting rather tired of
> people moving their files all over the tree all the time).
>
>   

Fine, I can stop bothering with putting up a test tree and just push the
stuff to Linus directly if that is what you prefer. Or is moving files
around barred from the kernel?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

