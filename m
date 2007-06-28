Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbXF1KmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbXF1KmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXF1KmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:42:13 -0400
Received: from mailgw12.fraunhofer.de ([153.96.1.24]:35841 "EHLO
	mailgw12.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbXF1KmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:42:12 -0400
Date: Thu, 28 Jun 2007 12:39:57 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: dwmw2@infradead.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       harald@skogtun.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <46838ffd.bUYvs93vY6OX67Mk%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
 <1182960282.1170.4.camel@pmac.infradead.org>
 <46838d16.ut8KQOMKsZ9HqPYT%Joerg.Schilling@fokus.fraunhofer.de>
 <1183027034.1170.104.camel@pmac.infradead.org>
In-Reply-To: <1183027034.1170.104.camel@pmac.infradead.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Jun 2007 10:41:56.0021 (UTC) FILETIME=[F28DE650:01C7B970]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2007-06-28 at 12:27 +0200, Joerg Schilling wrote:
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Wed, 2007-06-27 at 16:00 +0200, Joerg Schilling wrote:
> > > > Warning: *** linux/ext2_fs.h is not usable at all ***
> > > > Warning: *** This makes it impossible to support Linux file flags ***
> > > > You may try to compile using 'make COPTX=-DTRY_EXT2_FS'
> > >
> > > Again, can you be _specific_? Amusing though your consistent 'Lunix is
> > > broken' chants are, the only reason I'm bothering to participate in this
> > > thread is on the off-chance that something _productive_ will come of it.
> > 
> > I have been forced to add this test as too many people reported that they
> > have no been able to compile star on their Linux distribution. 
>
> But do you not know _why_? What exactly are you testing _for_?
>
> Bug reports which merely say 'is broken' are not helpful.

If you like to know what I test, I encourage you to check the autoconf
scripts. I am testing whether the named include file may be used from a 
user space program.

As I did mention already, I was forced to add the test in order to be able to
compile at all.


> > > By the way, your mailer seems to be sometimes omitting In-Reply-To: and
> > > References: headers, which RFC2822 says you SHOULD include in replies. 
> > 
> > Sending such accusation without knowing the reason is not polite.
>
> It's not an accusation -- it's merely an observation. You may not have
> noticed that your mailer was misbehaving; now you _do_ know, and if you
> care about RFC compliance you might want to fix it. You're not _obliged_
> to fix it, of course. I just thought you'd like to know.

Well there you are: my mailer is definitely NOT missbehaving.
Please do not repeat similar accusations when not knowing the reason.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
