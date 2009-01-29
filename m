Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZA2RPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZA2RPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZA2RPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:15:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35907 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZA2RPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:15:07 -0500
Date: Thu, 29 Jan 2009 17:14:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: OMAP clock fast-forward: an introduction to six series
Message-ID: <20090129171450.GG18233@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.00.0901281310590.14710@utopia.booyaka.com> <20090128211844.GI23301@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0901282357560.32081@utopia.booyaka.com> <20090129081117.GA11519@n2100.arm.linux.org.uk> <20090129083049.GB11519@n2100.arm.linux.org.uk> <20090129162556.GA32148@atomide.com> <20090129163501.GE18233@n2100.arm.linux.org.uk> <20090129164103.GD32148@atomide.com> <20090129165335.GI32148@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129165335.GI32148@atomide.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 08:53:35AM -0800, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [090129 08:42]:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [090129 08:35]:
> > > On Thu, Jan 29, 2009 at 08:25:58AM -0800, Tony Lindgren wrote:
> > > > To me it does not matter which way the stuff gets merged. We just need
> > > > to get it all merged.
> > > > 
> > > > If you guys can't get it merged and sorted out then it will all fall
> > > > down on me. And then I have to use tools no smaller than a sledgehammer
> > > > to merge it all, so the outcome won't be pretty!
> > > 
> > > Well, I've continued with my approach.  28 patches are currently merged
> > > onto a follow-on branch (scattered throughout the series but in order)
> > > and the result builds for my OMAP1, OMAP2 and OMAP3 test builds.
> > 
> > OK, only 32 more patches to go :)
> 
> I mean 42!

You were closer first time around - there's 9 patches I'm not going to merge
as they currently stand, which I've provided comments on.
