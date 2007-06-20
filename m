Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXFTVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXFTVeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXFTVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:34:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34939 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbXFTVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:34:04 -0400
Date: Wed, 20 Jun 2007 23:34:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Boldi <a1426z@gawab.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070620213419.GI12950@stusta.de>
References: <200706180141.41101.a1426z@gawab.com> <6bffcb0e0706171555p7ce2419eg2c91f40e22111b0f@mail.gmail.com> <200706180655.47998.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706180655.47998.a1426z@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 06:55:47AM +0300, Al Boldi wrote:
> Michal Piotrowski wrote:
> > On 18/06/07, Al Boldi <a1426z@gawab.com> wrote:
> > > Bartlomiej Zolnierkiewicz wrote:
> > > > On Sunday 17 June 2007, Andrew Morton wrote:
> > > > > We of course do want to minimise the amount of overhead for each
> > > > > developer. I'm a strong believer in specialisation: rather than
> > > > > requiring that *every* developer/maintainer integrate new steps in
> > > > > their processes it would be better to allow them to proceed in a
> > > > > close-to-usual fashion and to provide for a specialist person (or
> > > > > team) to do the sorts of things which you're thinking about.
> > > >
> > > > Makes sense... however we need to educate each and every developer
> > > > about importance of the code review and proper recognition of
> > > > reviewers.
> > >
> > > That's as easy to manage as is currently done with rc-regressions.
> >
> > Are you a volunteer?
> 
> Probably not, as this task requires a real PRO!
>...

That's wrong.

We are talking about _tracking_.

I'm not sure whether it makes much sense, and it would cost an enormous 
amount of time, but tracking patches should be possible without any 
knowledge of the kernel.

> Thanks!
> Al

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

