Return-Path: <linux-kernel-owner+w=401wt.eu-S934028AbYA2Th1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbYA2Th1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYA2ThK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:37:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58940 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751196AbYA2ThJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:37:09 -0500
Date: Tue, 29 Jan 2008 13:37:00 -0600
From: Paul Jackson <pj@sgi.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       rostedt@goodmis.org, menage@google.com, rientjes@google.com,
       tong.n.li@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, sgrubb@redhat.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       nickpiggin@yahoo.com.au
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129133700.7f1ab444.pj@sgi.com>
In-Reply-To: <479F1118.BA47.005A.0@novell.com>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
	<20080129053005.bc7a11d7.pj@sgi.com>
	<479F01AF.BA47.005A.0@novell.com>
	<20080129102836.be614579.pj@sgi.com>
	<479F1118.BA47.005A.0@novell.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory wrote:
> > 1) What are 'per-domain' variables?
> 
> s/per-domain/per-root-domain

Oh dear - now I've got more questions, not fewer.

 1) "variables"  ... what variables?

 2) Is a 'root-domain' just the RT specific portion
    of a sched_domain, or is it something else?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
