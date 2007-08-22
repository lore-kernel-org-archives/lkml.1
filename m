Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbXHVVxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbXHVVxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763358AbXHVVwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:52:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59422 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763465AbXHVVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:52:50 -0400
Date: Wed, 22 Aug 2007 23:51:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: TV card detected wrongly by the kernel. Any chance to get this
	fixed?
Message-ID: <20070822215148.GL30705@stusta.de>
References: <fai89b$ms1$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fai89b$ms1$1@sea.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:08:00PM +0200, Manuel Reimer wrote:
> Hello,
>
> I have a BT878 based TV card (was sold by a german discounter some years 
> ago).
>
> Unfortunately this card gets detected wrongly and so I'm unable to watch 
> tv, if I allow the kernel to auto-detect the card.
>
> If I unload the module and reload it using the right "card=" value, then 
> anything works well. So one of the first steps, I do if I install a new 
> version of my distribution, is to place the "unload module and reload with 
> the right value" code to my "rc.local" file.
>
> Is there any chance to get this card added to the kernel, so the right 
> value gets auto-loaded?

It might be possible, but the driver maintainer (Cc'ed) should know best.

What is the "card=" value you use?
What is the line for yor card in the "lspci -nn" output?

> Thanks in advance
>
> Yours
>
> Manuel Reimer

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

