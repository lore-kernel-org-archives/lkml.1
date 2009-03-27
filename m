Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbZC0Rmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbZC0Rmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZC0RmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:42:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53007 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213AbZC0RmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:42:23 -0400
Date: Fri, 27 Mar 2009 23:11:43 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu
	into spinlock
Message-ID: <20090327174143.GA24940@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com> <alpine.DEB.2.00.0903270904260.1917@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903270904260.1917@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 09:15:29AM -0400, Steven Rostedt wrote:
...

> Do you have CONFIG_FRAME_POINTER set?
>

Yes, CONFIG_FRAME_POINTER=y
 
> Is this running in a virtual box or bare metal? (probably should not matter)
> 

Bare metal.


> What version of gcc do you have?
> 
gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-44)


Thanks
Maneesh

-- 

Maneesh Soni
Linux Technology Center
IBM India Systems and Technology Lab,
Bangalore, India.
