Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZFRXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZFRXCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZFRXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:02:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:43198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbZFRXCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:02:12 -0400
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
 counters on 32-bit powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20090617142151.GB6846@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	 <20090617142151.GB6846@elte.hu>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 09:01:54 +1000
Message-Id: <1245366114.8693.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 16:21 +0200, Ingo Molnar wrote:
> > This depends on the generic atomic64_t patches, which are now in 
> > Linus' tree.  Ingo, if you're putting these in, please pull Linus' 
> > tree in first.
> 
> Note, i've created a new branch, tip:perfcounters/powerpc, so we can 
> keep these things separate and Ben can pull them too. I see there 
> was some review feedback - do you want to send a v2 version perhaps?

At this stage, I'm happy for you to push them. I was thinking about
moving the files around but that can wait. No serious comments on the
patches themselves on my side.

Cheers
Ben

