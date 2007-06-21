Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbXFUD1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbXFUD1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXFUD1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:27:33 -0400
Received: from [212.12.190.46] ([212.12.190.46]:32849 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752209AbXFUD1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:27:33 -0400
From: Al Boldi <a1426z@gawab.com>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: How to improve the quality of the kernel?
Date: Thu, 21 Jun 2007 06:26:20 +0300
User-Agent: KMail/1.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200706180141.41101.a1426z@gawab.com> <200706180655.47998.a1426z@gawab.com> <20070620213419.GI12950@stusta.de>
In-Reply-To: <20070620213419.GI12950@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706210626.20429.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jun 18, 2007 at 06:55:47AM +0300, Al Boldi wrote:
> > Michal Piotrowski wrote:
> > > On 18/06/07, Al Boldi <a1426z@gawab.com> wrote:
> > > > Bartlomiej Zolnierkiewicz wrote:
> > > > > On Sunday 17 June 2007, Andrew Morton wrote:
> > > > > > We of course do want to minimise the amount of overhead for each
> > > > > > developer. I'm a strong believer in specialisation: rather than
> > > > > > requiring that *every* developer/maintainer integrate new steps
> > > > > > in their processes it would be better to allow them to proceed
> > > > > > in a close-to-usual fashion and to provide for a specialist
> > > > > > person (or team) to do the sorts of things which you're thinking
> > > > > > about.
> > > > >
> > > > > Makes sense... however we need to educate each and every developer
> > > > > about importance of the code review and proper recognition of
> > > > > reviewers.
> > > >
> > > > That's as easy to manage as is currently done with rc-regressions.
> > >
> > > Are you a volunteer?
> >
> > Probably not, as this task requires a real PRO!
> >...
>
> That's wrong.
>
> We are talking about _tracking_.
>
> I'm not sure whether it makes much sense, and it would cost an enormous
> amount of time, but tracking patches should be possible without any
> knowledge of the kernel.

If that's really true, which I can't imagine, then the proper way forward 
would probably involve a fully automated system.


Thanks!

--
Al

