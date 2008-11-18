Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbYKRRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbYKRRC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYKRRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:02:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYKRRCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:02:18 -0500
Message-ID: <4922F505.9010709@zytor.com>
Date: Tue, 18 Nov 2008 09:01:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Joe Korty <joe.korty@ccur.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Support always running TSC on Intel CPUs
References: <20081118001137.GA12350@linux-os.sc.intel.com> <20081118080952.GE17838@elte.hu> <20081118145540.GA32082@tsunami.ccur.com> <20081118160542.GC8088@elte.hu> <7E82351C108FA840AB1866AC776AEC464291BB4F@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464291BB4F@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> But, I agree it is confusing.
> 
> How about?
> X86_FEATURE_FIXEDFREQ_MAYSTOP_TSC
> X86_FEATURE_ALWAYS_RUNNING_TSC
> 

A bit verbose, don't you think?

Either way, there seems to be, functionally, C2_TSC and C3PLUS_TSC for 
different CPUs...

	-hpa

