Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbXFVSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbXFVSp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXFVSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:45:19 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43630
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944AbXFVSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:45:18 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "dave young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Date: Fri, 22 Jun 2007 14:45:22 -0400
User-Agent: KMail/1.9.6
Cc: "Li Yang" <leoli@freescale.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, torvalds@linux-foundation.org
References: <1182436817579-git-send-email-leoli@freescale.com> <200706220133.19496.rob@landley.net> <a8e1da0706212307l7bdebbabl72478d1c734b60bd@mail.gmail.com>
In-Reply-To: <a8e1da0706212307l7bdebbabl72478d1c734b60bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221445.24353.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 02:07:57 dave young wrote:
> > > Yes, I agree with you, and there's so many other languages, It's
> > > better for someone to  create a standalone kdoc translation project
> > > than to merge them into kernel.
> >
> > I wasn't suggesting merging them into the kernel.
>
> I'm misunderstanded.
>
> I means:
> Yes, I agree with you.
> There's so many other languages, It's better for someone to  create a
> standalone kdoc translation project than to merge them into kernel.

I agree, but this is just an opinion.  (I see where Greg KH wants to merge it 
into the kernel.)

> > The question is, do the kernel developers want to encourage people who
> > don't speak English to mess with the kernel, any more than they want to
> > encourage kernel developers who don't know C?  Is kernel documentation in
> > Chinese a better idea than a repository of kernel patches in C++? 
> > (Either way, work resulting from this is much less likely than normal to
> > be merged into the kernel.)
>
> It's another issue.
>
> Someone don't speak english , but it don't means they haven't
> programming skilles. As long as one can help to promote the kernel
> development  he is welcomed.

I agree that programming talent can exist without the ability to speak 
English.  But will the resulting patches get merged if the developer can't 
communicate with the Linux development community?

I dealt with a programmer on the BusyBox project who only speaks Russian, and 
uses a babelfish variant to translate everything.  This was incredibly 
frustrating: he regularly misunderstood what we were saying, we regularly had 
no idea what he was saying, his attempts at commenting the code were often 
worse than not commeting it at all, and after three years his ability to 
communicate hadn't improved in the slightest.

Possibly we'd need some volunteer translators just for the purpose of merging 
code in languages we'd translated the documentation into?  A "chinese patch 
maintainer" or some such?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
