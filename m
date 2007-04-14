Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXDNTsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXDNTsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXDNTsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:48:54 -0400
Received: from holomorphy.com ([66.93.40.71]:55979 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXDNTsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:48:53 -0400
Date: Sat, 14 Apr 2007 12:48:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414194855.GZ2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414083625.GM943@1wt.eu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 10:36:25AM +0200, Willy Tarreau wrote:
> Forking becomes very slow above a load of 100 it seems. Sometimes,
> the shell takes 2 or 3 seconds to return to prompt after I run
> "scheddos &"
> Those are very promising results, I nearly observe the same responsiveness
> as I had on a solaris 10 with 10k running processes on a bigger machine.
> I would be curious what a mysql test result would look like now.

Where is scheddos?


-- wli
