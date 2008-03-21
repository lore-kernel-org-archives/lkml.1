Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYCUOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYCUOvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYCUOvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:51:13 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48863 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbYCUOvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:51:12 -0400
Date: Fri, 21 Mar 2008 20:21:47 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yakov Lerner <iler.ml@gmail.com>, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080321145147.GC7394@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080321110804.GY20420@elte.hu> <20080321113134.GA7620@in.ibm.com> <20080321143229.GE31719@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321143229.GE31719@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:32:29PM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > > thanks, i've added your patch to the .26 bucket of x86.git, but it 
> > > would be nice to get an Ack/Nack from a kprobes person as well.
> >  
> > Ingo,
> > 
> > I've tested Yakov's more comprehensive patch on powerpc too. This has 
> > my ack.
> > 
> > Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> thanks, i've queued up the x86-only patch below for .26 merging. (that 
> is all that is needed for x86, and no .25 urgency, right?)

Yup. This can wait for .26

Ananth
