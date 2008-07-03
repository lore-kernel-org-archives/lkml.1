Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYGCU51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYGCU51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 16:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYGCU5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 16:57:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGCU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 16:57:19 -0400
Subject: Re: [ANNOUNCE] sched: schedtop utility
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ankita Garg <ankita@in.ibm.com>, Gregory Haskins <ghaskins@novell.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       David Bahi <DBahi@novell.com>
In-Reply-To: <20080703083412.GA7873@elte.hu>
References: <483545B4.BA47.005A.0@novell.com>
	 <20080602124822.GA15410@in.ibm.com>
	 <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
	 <20080605052008.GA7635@in.ibm.com> <1213871234.10476.12.camel@twins>
	 <20080701090006.GA7814@in.ibm.com>  <20080703083412.GA7873@elte.hu>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 22:56:37 +0200
Message-Id: <1215118598.28676.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 10:34 +0200, Ingo Molnar wrote:
> * Ankita Garg <ankita@in.ibm.com> wrote:
> 
> > > OK, so task delay delay accounting is broken because it doesn't take
> > > migration into account.
> 
> > Fixed. Pl. find the new patch below.
> 
> applied to tip/sched/devel - thanks Ankita.

ACK

