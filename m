Return-Path: <linux-kernel-owner+w=401wt.eu-S936689AbXG0VUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936689AbXG0VUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXG0VUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:20:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46889 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753563AbXG0VUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:20:42 -0400
Date: Fri, 27 Jul 2007 23:20:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       Thierry MERLE <thierry.merle@free.fr>,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [2/2] 2.6.23-rc1: known regressions with patches v2
Message-ID: <20070727212015.GA15129@stusta.de>
References: <46AA5A28.3090205@googlemail.com> <46AA5B4A.40500@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46AA5B4A.40500@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 10:53:30PM +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.23-rc1
> with patches available.
> 
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>...
> Media
> 
> Subject         : usbvision: don't return an uninitialized value
> References      : http://lkml.org/lkml/2007/7/23/65
> Last known good : ?
> Submitter       : Adrian Bunk <bunk@stusta.de>
> Caused-By       : ?
> Handled-By      : Adrian Bunk <bunk@stusta.de>
> Patch           : http://lkml.org/lkml/2007/7/23/65
> Status          : patch available
>...

There's a better patch available, updated entry:

Subject         : usbvision: don't return an uninitialized value
References      : http://lkml.org/lkml/2007/7/23/65
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : Thierry MERLE <thierry.merle@free.fr>
                  commit c5f48367fe54c46805774eeea8e828de54a5ad7b
Handled-By      : Trent Piepho <xyzzy@speakeasy.org>
Patch           : http://lkml.org/lkml/2007/7/23/114
Status          : patch available


> Regards,
> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

