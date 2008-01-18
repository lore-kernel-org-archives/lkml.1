Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYAROF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYAROF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYAROFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:05:17 -0500
Received: from waste.org ([66.93.16.53]:50904 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYAROFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:05:15 -0500
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080118135704.GB12702@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com>
	 <478F8AEC.1080209@free-electrons.com>
	 <1200590031.5332.19.camel@cinder.waste.org>
	 <200801172315.29976.michael-lists@free-electrons.com>
	 <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>
	 <20080118122540.GH11044@elte.hu> <20080118122926.GA15216@elte.hu>
	 <4790A385.800@free-electrons.com>
	 <1200664214.4001.24.camel@cinder.waste.org>
	 <20080118135704.GB12702@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 08:04:39 -0600
Message-Id: <1200665079.4001.32.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 14:57 +0100, Ingo Molnar wrote:
> [ Sidenote: "too small" and "too insignificant" is not a patch attribute
>   that is in my vocabulary - by definition the best patches are very
>   small and very insignificant (they just happen to end up doing
>   something cool a 1000 steps later ;-) 99% of our problems come from
>   'too large' and 'too intrusive' patches. ]

I tend to agree, but it's well-established that not everyone here is so
patient.

-- 
Mathematics is the supreme nostalgia of our time.

