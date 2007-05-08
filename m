Return-Path: <linux-kernel-owner+w=401wt.eu-S967975AbXEHFbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967975AbXEHFbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967967AbXEHFbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:31:09 -0400
Received: from holomorphy.com ([66.93.40.71]:44746 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967879AbXEHFbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:31:08 -0400
Date: Mon, 7 May 2007 22:31:32 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-ID: <20070508053132.GZ31925@holomorphy.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org> <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org> <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org> <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507222409.2d597a86.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> I'm using wli's 8k
>> stack + irq stack patches with good success though.

On Mon, May 07, 2007 at 10:24:09PM -0700, Andrew Morton wrote:
> wlis are handy.

I think Andi's handling the mergework on those patches, but I'll check
in to see if I should rediff vs. -mm or what if you want them.

Andi, what's the verdict on those stack patches?


-- wli
