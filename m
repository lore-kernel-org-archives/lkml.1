Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbZJ2Cnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbZJ2Cnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZJ2Cnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:43:52 -0400
Received: from ozlabs.org ([203.10.76.45]:45477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZJ2Cnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:43:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19177.352.47019.4942@drongo.ozlabs.ibm.com>
Date: Thu, 29 Oct 2009 13:43:44 +1100
From: Paul Mackerras <paulus@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] perf_event/tracing/powerpc patches from Anton
 Blanchard
In-Reply-To: <1256780668.26770.15.camel@pasglop>
References: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
	<1256780668.26770.15.camel@pasglop>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:

> On Thu, 2009-10-29 at 11:56 +1100, Paul Mackerras wrote:
> > Here is a series of patches from Anton Blanchard that implement some
> > nice tracing and perf_event features on powerpc.  One of them is
> > generic perf_event stuff (adding software events for alignment faults
> > and instruction emulation faults).
> > 
> > Since this touches the perf_event and tracing subsystems as well as the
> > powerpc architecture code, I think the best way forward is for both
> > Ingo and Ben to pull it into their trees.  I have based it on the most
> > recent point in Linus' tree that Ingo had pulled into his perf
> > branches (as of yesterday or so).
> 
> This is -next material right ?

Yes, please pull it into your next branch.

Thanks,
Paul.
