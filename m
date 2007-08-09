Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbXHIUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbXHIUSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbXHIUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:17:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50189 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757149AbXHIUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:17:57 -0400
Date: Thu, 9 Aug 2007 22:17:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What does 'if EMBEDDED' mean?
Message-ID: <20070809201742.GA14250@stusta.de>
References: <4104961b0708090711j291974cbx933e1262ba1935f6@mail.gmail.com> <20070809141621.GO6997@stusta.de> <4104961b0708090743t810dadbp37521425120c2ed2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4104961b0708090743t810dadbp37521425120c2ed2@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:43:10PM +0800, jidong xiao wrote:
> On 8/9/07, Adrian Bunk <bunk@kernel.org> wrote:
> >
> > Say "y" at
> >  General setup
> >    Configure standard kernel features (for small systems)
> >
> > cu
> > Adrian
> >
> 
> Thank you, Adrian, it's very clear.
> 
> By the way, can sysfs be compiled as a module?Does bool type mean this
> option cannot be compiled as a module?

"bool" means it can't be compiled as a module.

Why do you want to compile it as a module?

> Regards
> Jason

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

