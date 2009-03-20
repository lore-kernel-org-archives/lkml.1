Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZCTRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZCTRt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbZCTRtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:49:20 -0400
Received: from www.tglx.de ([62.245.132.106]:40986 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbZCTRtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:49:20 -0400
Date: Fri, 20 Mar 2009 18:48:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cliff Brake <cliff.brake@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: Re: [Announce] 2.6.29-rc78rt1
In-Reply-To: <f96d234e0903200931w2d57155cm81b67265d42861bf@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903201846080.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>  <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> 
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>  <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <f96d234e0903200931w2d57155cm81b67265d42861bf@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Cliff Brake wrote:

> On Thu, Mar 19, 2009 at 8:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> 
> > P.S.: ARM/PowerPC support is in the pipeline and will be available
> > with -rt2 (hopefully :)
> 
> Do you have a time estimate for -rt2/ARM support, and is there

Time estimate is about: now minus 20sec :)

> anything that can be done to help (testing, etc).

Yup, the patches need full testing.

Thanks,

	tglx


