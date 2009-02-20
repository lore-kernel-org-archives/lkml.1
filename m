Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZBTR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZBTR7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZBTR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:59:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZBTR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:58:59 -0500
Date: Fri, 20 Feb 2009 12:58:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull v2] x86 page fault checker
In-Reply-To: <20090220175239.GM24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201258060.13747@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com> <20090220155036.GA3225@elte.hu> <alpine.DEB.2.00.0902201232510.13747@gandalf.stny.rr.com> <20090220175239.GM24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I added your suggestion, and even tested it out. I cherry picked
> > a branch to remove your split_large fix, added this output, and then
> > added the changes that triggered the original bug. I got a very nasty 
> > warning, but the kernel resumed fine.
> 
> Pulled into tip:x86/mm. It's not urgent in terms of .29 
> material, agreed?

Yeah, it is just an added precaution. It can wait till .30

-- Steve

