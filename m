Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbXIXXGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbXIXXGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXIXXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:06:37 -0400
Received: from alnrmhc16.comcast.net ([206.18.177.56]:45501 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbXIXXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:06:37 -0400
Subject: Re: Mask Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Mel Gorman <mel@skynet.ie>
Cc: kernel list <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
In-Reply-To: <20070924153920.GB32550@skynet.ie>
References: <1190242676.16474.6.camel@localhost>
	 <20070924153920.GB32550@skynet.ie>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 18:07:47 -0500
Message-Id: <1190675267.17721.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 16:39 +0100, Mel Gorman wrote:
> On (19/09/07 17:57), Chris Holvenstot didst pronounce:
> > Still being a little new at this I am not sure if this is an issue at
> > all or not but I noted that while building the 2.6.23-rc6-git8 kernel
> > this afternoon I received the following error message: 
> > 
> > Building modules, stage 2.
> >   MODPOST 1670 modules
> > WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0
> > 
> > I have been building each of the kernels in the 2.6.23-rc series and had
> > not noted this message before.  I apologize if this is a non-issue.
> > 
> 
> I noticed this in a -mm recently and never got around to kicking it
> properly because I suspected it was a compiler issue. What version
> of gcc and binutils are you using?
> 
> David Woodhouse added to cc in case this is a known problem.
> 

Mel - 

Thank you for the response.  I was a little unsure if this was to
trivial to report.  

In any case to answer your question I use version 4.1.2 of GCC and the
binutils package shows as 2.17.20070103cvs-0ubuntu2

Chris



