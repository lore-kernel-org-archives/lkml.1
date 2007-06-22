Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbXFVFd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbXFVFd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFVFdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:33:21 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41412
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXFVFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:33:20 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "dave young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Date: Fri, 22 Jun 2007 01:33:18 -0400
User-Agent: KMail/1.9.6
Cc: "Li Yang" <leoli@freescale.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>, torvalds@linux-foundation.org
References: <1182436817579-git-send-email-leoli@freescale.com> <200706212248.34128.rob@landley.net> <a8e1da0706212023k5acfbf83g2a11c36720d775cf@mail.gmail.com>
In-Reply-To: <a8e1da0706212023k5acfbf83g2a11c36720d775cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220133.19496.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007 23:23:54 dave young wrote:
> Hi,
>
> 2007/6/22, Rob Landley <rob@landley.net>:
> > On Thursday 21 June 2007 10:40:17 Li Yang wrote:
> > > This is a Chinese translated version of Documentation/HOWTO.  Currently
> > > Chinese involvement in Linux kernel is very low, especially comparing
> > > to its largest population base.  Language could be the main obstacle. 
> > > Hope this document will help more Chinese to contribute to Linux
> > > kernel.
> >
> > I'm putting together a kernel documentation directory at
> > http://kernel.org/doc and I could easily add translations in there.  I
> > just don't know if this is a good idea.
>
> I think it's not a good idea to merge translations into kernel.
>
> > The problem is, the submission of patches happens on the various
> > kernel.org mailing lists, which are all in English.  Kernel development
> > is done in a single common language: English.  (If you'd like to argue
> > for it to be done in another language, please make the proposal in
> > Linus's native Swedish.)
>
> Yes, I agree with you, and there's so many other languages, It's
> better for someone to  create a standalone kdoc translation project
> than to merge them into kernel.

I wasn't suggesting merging them into the kernel.

I'm doing a web page to put together html versions of lots of kernel 
documentation in a place Google can find it.  Peter Anvin was kind enough to 
give me http://kernel.org/doc for this.  It would not be technically 
difficult for this web page to host translated versions of this 
documentation.

The question is, do the kernel developers want to encourage people who don't 
speak English to mess with the kernel, any more than they want to encourage 
kernel developers who don't know C?  Is kernel documentation in Chinese a 
better idea than a repository of kernel patches in C++?  (Either way, work 
resulting from this is much less likely than normal to be merged into the 
kernel.)

I don't know if this is a valid concern or not.  That's why I'm asking.

Rob

P.S.  The hardest part of putting together a kernel documentation web page is 
actually indexing it coherently.  It's not very useful to just dump together 
huge amounts of stuff from Documentation and make htmldocs and linux weekly 
news' kernel index and kerneltrap and kernel traffic and the kernelnewbies 
wiki and kernelplanet and man-pages-2.57 coverted to html with doclifter...  
Ahem.  I finally figured out how I wanted it indexed, made a skeleton to hang 
stuff on, and my laptop blew up.  Grrr.  Mostly recovered, but now OLS is 
bearing down on me and I still haven't got a new laptop...

Don't mind me, I'll catch up.
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
