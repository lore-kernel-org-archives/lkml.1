Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbXIPS3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbXIPS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXIPS3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:29:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48099 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXIPS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:29:01 -0400
Date: Sun, 16 Sep 2007 20:28:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
Message-ID: <20070916182859.GF14501@one.firstfloor.org>
References: <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com> <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org> <46EC6F2A.5090008@oracle.com> <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org> <20070916094001.d87ed0f0.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 10:14:46AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 16 Sep 2007, Randy Dunlap wrote:
> > 
> > I'll apply this patch today, but I haven't done so yet (for the 2
> > bug reports below).
> 
> Actually, it's probably better that you don't change your situation 
> unnecessarily, in case the bug goes away.

I checked the Prescott Specification Update, but didn't seen anything
that could cause such strange faults.

I'm trying to reproduce it here.

-Andi

