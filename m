Return-Path: <linux-kernel-owner+w=401wt.eu-S1423289AbXD3Num@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423289AbXD3Num (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423290AbXD3Num
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:50:42 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:54392 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423289AbXD3Nul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:50:41 -0400
Message-ID: <4635F467.9090302@drzeus.cx>
Date: Mon, 30 Apr 2007 15:51:35 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/36] Use menuconfig objects II - MMC
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 

Just a heads up, I'll be pushing the restructuring stuff to Linus in a bit and
it will most likely break this patch. I'll hack together an update and send to you.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
