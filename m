Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0AOJul (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211Ab0AOJuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:50:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:53568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab0AOJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:50:39 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100115093831.GC26396@in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546228.4244.343.camel@laptop>  <20100115093831.GC26396@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 10:50:14 +0100
Message-ID: <1263549014.4244.374.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 15:08 +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jan 15, 2010 at 10:03:48AM +0100, Peter Zijlstra wrote:
> > On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > > 
> > >  discussed elsewhere. 
> > 
> > Thanks for the pointer...
> 
> :-)
> 
> Peter,
> I think Jim was referring to
> http://sources.redhat.com/ml/systemtap/2007-q1/msg00571.html

That's a 2007 email from some obscure list... that's hardly something
that can be referenced to without link.

As previously stated, I think poking at a process's address space is an
utter no-go.

