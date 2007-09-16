Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXIPDK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXIPDK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 23:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXIPDKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 23:10:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43830 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbXIPDKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 23:10:16 -0400
Date: Sun, 16 Sep 2007 05:10:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
Message-ID: <20070916031014.GD14501@one.firstfloor.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com> <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org> <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 03:47:19PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 15 Sep 2007, Linus Torvalds wrote:
> > 
> > So regardless of whether we want to trust "user_mode(regs)" more than 
> > "error_code & PF_USER", it would definitely be very interesting if you can 
> > give a good "this is where it started happening".
> 
> Also, can you point to good crashme sources, and give the arguments you 

LTP (http://ltp.sourceforge.net) should have a modern crashme.

-Andi

