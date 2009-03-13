Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZCME0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZCME0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZCMEZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:25:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZCMEZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:25:49 -0400
Date: Fri, 13 Mar 2009 00:25:43 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Kyle McMartin <kyle@infradead.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-m68k@vger.kernel.org, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 0/7] Generic RTC class driver
Message-ID: <20090313042543.GA3907@bombadil.infradead.org>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <alpine.LRH.2.00.0903111134270.1040@vixen.sonytel.be> <20090311154505.GB5448@bombadil.infradead.org> <alpine.LRH.2.00.0903111825040.1040@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903111825040.1040@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 06:26:12PM +0100, Geert Uytterhoeven wrote:
> 	Hi Kyle,
> 
> On Wed, 11 Mar 2009, Kyle McMartin wrote:
> > On Wed, Mar 11, 2009 at 11:36:02AM +0100, Geert Uytterhoeven wrote:
> > > Is it OK for you to take it through your PA-RISC tree?
> > > If yes, I can resend the patch series with the collected acks.
> > 
> > That's fine with me, just hit me up with a git tree address and I'll
> > suck it all into the rtc-parisc tree?
> 
> I put it up at:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-rtc-generic.git
> 
> The master branch should be a descendant of your rtc-parisc branch.
> 
> Thanks!
>

Great, thanks Geert!

I've pulled it and pushed it back out, I'll submit it when the merge
window opens.

cheers, Kyle
