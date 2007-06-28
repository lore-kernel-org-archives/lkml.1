Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbXF1Kh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbXF1Kh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXF1KhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:37:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbXF1KhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:37:20 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       harald@skogtun.org, david@lang.hm
In-Reply-To: <46838d16.ut8KQOMKsZ9HqPYT%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
	 <1182960282.1170.4.camel@pmac.infradead.org>
	 <46838d16.ut8KQOMKsZ9HqPYT%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 11:37:14 +0100
Message-Id: <1183027034.1170.104.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 12:27 +0200, Joerg Schilling wrote:
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Wed, 2007-06-27 at 16:00 +0200, Joerg Schilling wrote:
> > > Warning: *** linux/ext2_fs.h is not usable at all ***
> > > Warning: *** This makes it impossible to support Linux file flags ***
> > > You may try to compile using 'make COPTX=-DTRY_EXT2_FS'
> >
> > Again, can you be _specific_? Amusing though your consistent 'Lunix is
> > broken' chants are, the only reason I'm bothering to participate in this
> > thread is on the off-chance that something _productive_ will come of it.
> 
> I have been forced to add this test as too many people reported that they
> have no been able to compile star on their Linux distribution. 

But do you not know _why_? What exactly are you testing _for_?

Bug reports which merely say 'is broken' are not helpful.

> > By the way, your mailer seems to be sometimes omitting In-Reply-To: and
> > References: headers, which RFC2822 says you SHOULD include in replies. 
> 
> Sending such accusation without knowing the reason is not polite.

It's not an accusation -- it's merely an observation. You may not have
noticed that your mailer was misbehaving; now you _do_ know, and if you
care about RFC compliance you might want to fix it. You're not _obliged_
to fix it, of course. I just thought you'd like to know.

-- 
dwmw2

