Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab0AOVTl (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681Ab0AOVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:19:40 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51542 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0AOVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:19:40 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263549014.4244.374.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
	 <1263549014.4244.374.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 13:19:31 -0800
Message-Id: <1263590371.5007.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-15 at 10:50 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-15 at 15:08 +0530, Ananth N Mavinakayanahalli wrote:
> > On Fri, Jan 15, 2010 at 10:03:48AM +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > > > 
> > > >  discussed elsewhere. 
> > > 
> > > Thanks for the pointer...
> > 
> > :-)
> > 
> > Peter,
> > I think Jim was referring to
> > http://sources.redhat.com/ml/systemtap/2007-q1/msg00571.html
> 
> That's a 2007 email from some obscure list... that's hardly something
> that can be referenced to without link.

Actually, I was referring to this
http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/01120.html
from earlier (Monday) in this same discussion.  But I'll be sure to
include pointers in the future.

For more thoughts on this approach, see
http://sourceware.org/bugzilla/show_bug.cgi?id=5509
(And no, I don't expect you to have seen that before. :-))  Most of the
troublesome issues mentioned in that enhancement request have since been
resolved.

Jim

