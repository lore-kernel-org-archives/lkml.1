Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYFDVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYFDVKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYFDVKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:10:07 -0400
Received: from mx2.compro.net ([216.54.166.4]:55945 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675AbYFDVKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:10:03 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 17:10:03 EDT
X-IronPort-AV: E=Sophos;i="4.27,591,1204520400"; 
   d="scan'208";a="2304712"
Message-ID: <48470250.6010803@compro.net>
Date: Wed, 04 Jun 2008 17:00:00 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Mark Hounschell <dmarkh@cfl.rr.com>, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, ioe-lkml@rameria.de,
       linux-kernel@vger.kernel.org, kernel@kolivas.org, dfults@sgi.com,
       devik@cdi.cz, sivanich@sgi.com, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, maxk@qualcomm.com, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	<200806030035.58387.ioe-lkml@rameria.de>	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	<200806031603.40731.nickpiggin@yahoo.com.au>	<48466745.5050802@cfl.rr.com> <20080604122644.cd73bfb9.pj@sgi.com>
In-Reply-To: <20080604122644.cd73bfb9.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Mark wrote:
>> What is an abonination, is that cpusets are equired for this type of 
>> isolation to begin with, even on a 2 processor machine.
> 
> Just to be sure I'm following you here, you stating that you
> want to be able to manipulate the isolated cpu map at runtime,
> not just with the boot option isolcpus, right? 
> Where this
> isolated cpu map works just fine even on systems which do
> not have cpusets configured, right?
>

Yes to both questions. However after reading Max and Peter's response, I
guess there is another, probably better or _only_, way to get what I really
need anyway so please don't consider my intrusion into this thread as a NAK.

I do not rely on this option as it is implemented. 

Regards
Mark
  



