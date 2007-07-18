Return-Path: <linux-kernel-owner+w=401wt.eu-S1761827AbXGRB3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761827AbXGRB3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXGRB3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:29:40 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58021 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXGRB3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:29:39 -0400
Date: Tue, 17 Jul 2007 18:28:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, devel@openvz.org,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: [PATCH] Fix leaks on
	/proc/{*/sched,sched_debug,timer_list,timer_stats}
Message-ID: <20070718012839.GA4307@sequoia.sous-sol.org>
References: <20070717122511.GD25083@localhost.sw.ru> <20070717123511.GB17657@elte.hu> <20070717175346.da0899f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717175346.da0899f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> Sorry, but I can't be bothered splitting it up.  Greg, Chris: please just
> apply the bits which apply and drop the other bits if that's OK.

Yup
