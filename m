Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYDZUfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYDZUfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbYDZUfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:35:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758518AbYDZUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:35:45 -0400
Date: Sat, 26 Apr 2008 13:35:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426133049.187e255c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804261333200.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <481379BB.5050208@s5r6.in-berlin.de> <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org> <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
 <20080426133049.187e255c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Andrew Morton wrote:

> On Sat, 26 Apr 2008 12:18:34 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So it's an important part of the process to try to do a good job, and not 
> > publicizing crap - but it's *equally* important to realize that crap 
> > happens, and that it's easily *more* distracting to try to clean it up 
> > after-the-fact than it is to just admit that it happened.
> 
> Fact is, this is the way in which developers want to work.  That is their
> workflow, and their tools should follow their workflow.  If a tool's
> behaviour prevents them from implementing their desired workflow, it isn't
> the workflow which should be changed ;)

But that was exactly my point. Bugs *will* happen. Follow-up patches 
*will* happen. Don't fight it. Do the best you can do - there's no way 
people will ever avoid all bugs to begin with. 

And trying to white-wash things later is just pointless and actively 
*bad*, when others have already seen and merged the original patches.

			Linus
