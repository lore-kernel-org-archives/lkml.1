Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbZFQOYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbZFQOYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZFQOYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:24:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:37119 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZFQOYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:24:22 -0400
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Message-Id: <8C6954A9-BE4C-47F5-AD87-A1D0EAF43F8A@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090617142151.GB6846@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software counters on 32-bit powerpc
Date: Wed, 17 Jun 2009 09:24:02 -0500
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <20090617142151.GB6846@elte.hu>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2009, at 9:21 AM, Ingo Molnar wrote:

>
> * Paul Mackerras <paulus@samba.org> wrote:
>
>> This depends on the generic atomic64_t patches, which are now in
>> Linus' tree.  Ingo, if you're putting these in, please pull Linus'
>> tree in first.
>
> Note, i've created a new branch, tip:perfcounters/powerpc, so we can
> keep these things separate and Ben can pull them too. I see there
> was some review feedback - do you want to send a v2 version perhaps?

Out of interest, is the intent to try and get these changes into .31?   
I ask because I want to know if I should try to find time to add  
support for the FSL embedded perfmon ASAP or not.

- k
