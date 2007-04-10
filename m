Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbXDJXT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbXDJXT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXDJXT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:19:28 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47084 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbXDJXT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:19:27 -0400
Date: Wed, 11 Apr 2007 01:19:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-ID: <20070410231934.GA10141@stusta.de>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <461C09D6.40805@s5r6.in-berlin.de> <Pine.LNX.4.61.0704110006320.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704110006320.32056@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:09:01AM +0200, Jan Engelhardt wrote:
> 
> On Apr 11 2007 00:04, Stefan Richter wrote:
> >
> >[...] I tried one of the patches
> >  - with make xconfig: OK
> >  - with make gconfig: OK
> >  - with make menuconfig: less so, because:
> >When one switches a menuconfig _on_, one might miss that there are
> >subsequent options to configure.  (Although the availability of further
> >options is indicated by the '--->' suffix to the menu title.)
> 
> The kconfig files had some menuconfigs for some time (CONFIG_EMBEDDED to be
> one). I do not think these menu entry types are unknown.

And the EMBEDDED menu has the interesting property that it's not empty 
with CONFIG_EMBEDDED=n .

> Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

