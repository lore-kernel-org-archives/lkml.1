Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab0BHMAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:00:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0BHMAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:00:19 -0500
Subject: Re: [RFC][PATCH] PERF_COUNT_SW_RUNNABLE_TASKS: measure and act
 upon parallellism
From: Peter Zijlstra <peterz@infradead.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       efault@gmx.de, andrea@suse.de, akpm@linux-foundation.org,
       Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <c76f371a1002080352ta0a2f7jd7945dc8f834c2cd@mail.gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
	 <1265623245.1853.33.camel@laptop>
	 <c76f371a1002080352ta0a2f7jd7945dc8f834c2cd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 12:59:52 +0100
Message-ID: <1265630392.1853.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 12:52 +0100, Stijn Devriendt wrote:
> Isn't no longer making --chain-reply-to the default an option?

That will hopefully happen on the next major git release (1.7 iirc).

