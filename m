Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZBFN2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZBFN2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZBFN2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:28:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZBFN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:28:03 -0500
Date: Fri, 6 Feb 2009 08:28:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 0/2] ftrace: updates for powerpc
In-Reply-To: <1233903859.4612.119.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0902060827260.10059@gandalf.stny.rr.com>
References: <20090206060328.181057235@goodmis.org> <1233903859.4612.119.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Benjamin Herrenschmidt wrote:

> On Fri, 2009-02-06 at 01:03 -0500, Steven Rostedt wrote:
> > Paul,
> > 
> > The first patch is a ftrace clean up to use the proper pr_debug macro.
> > 
> > The second patch is to fix a compile error when dynamic ftrace
> > is compiled in, but modules are not.
> 
> Did you find out the problem with the large USB module ?

Not yet, I'm still trying to figure out why it does things differently on 
large modules.

-- Steve

