Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbXFUNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbXFUNH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXFUNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:07:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35385 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754865AbXFUNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:07:19 -0400
Date: Thu, 21 Jun 2007 15:07:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Boldi <a1426z@gawab.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070621130737.GN12950@stusta.de>
References: <200706180141.41101.a1426z@gawab.com> <200706180655.47998.a1426z@gawab.com> <20070620213419.GI12950@stusta.de> <200706210626.20429.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706210626.20429.a1426z@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 06:26:20AM +0300, Al Boldi wrote:
> Adrian Bunk wrote:
> > On Mon, Jun 18, 2007 at 06:55:47AM +0300, Al Boldi wrote:
> > > Michal Piotrowski wrote:
> > > > On 18/06/07, Al Boldi <a1426z@gawab.com> wrote:
> > > > > Bartlomiej Zolnierkiewicz wrote:
> > > > > > On Sunday 17 June 2007, Andrew Morton wrote:
> > > > > > > We of course do want to minimise the amount of overhead for each
> > > > > > > developer. I'm a strong believer in specialisation: rather than
> > > > > > > requiring that *every* developer/maintainer integrate new steps
> > > > > > > in their processes it would be better to allow them to proceed
> > > > > > > in a close-to-usual fashion and to provide for a specialist
> > > > > > > person (or team) to do the sorts of things which you're thinking
> > > > > > > about.
> > > > > >
> > > > > > Makes sense... however we need to educate each and every developer
> > > > > > about importance of the code review and proper recognition of
> > > > > > reviewers.
> > > > >
> > > > > That's as easy to manage as is currently done with rc-regressions.
> > > >
> > > > Are you a volunteer?
> > >
> > > Probably not, as this task requires a real PRO!
> > >...
> >
> > That's wrong.
> >
> > We are talking about _tracking_.
> >
> > I'm not sure whether it makes much sense, and it would cost an enormous
> > amount of time, but tracking patches should be possible without any
> > knowledge of the kernel.
> 
> If that's really true, which I can't imagine, then the proper way forward 
> would probably involve a fully automated system.

If you consider any kind of patch tracking valuable, you should either 
do it yourself or write the tool yourself. In both cases, the 
interesting parts would be how to integrate it into the workflow of 
kernel development without creating extra work for anyone and how to get 
the information into the got commits.

"requires a real PRO" and "would probably involve" sound like cheap 
phrases for avoiding doing any work yourself.

Talk is cheap, but unless YOU will do it your emails will only be a 
waste of bandwidth.

> Thanks!
> Al

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

