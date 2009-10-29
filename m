Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZJ2G5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZJ2G5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZJ2G5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:57:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZJ2G5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:57:10 -0400
Date: Thu, 29 Oct 2009 07:55:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [GIT PULL] perf_event/tracing/powerpc patches from Anton
	Blanchard
Message-ID: <20091029065501.GB12874@elte.hu>
References: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Here is a series of patches from Anton Blanchard that implement some 
> nice tracing and perf_event features on powerpc.  One of them is 
> generic perf_event stuff (adding software events for alignment faults 
> and instruction emulation faults).
> 
> Since this touches the perf_event and tracing subsystems as well as 
> the powerpc architecture code, I think the best way forward is for 
> both Ingo and Ben to pull it into their trees.  I have based it on the 
> most recent point in Linus' tree that Ingo had pulled into his perf 
> branches (as of yesterday or so).

The generic perf bits look good to me - can pull it if Ben OKs the 
PowerPC bits.

Thanks,

	Ingo
