Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbZHZA0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbZHZA0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZHZA0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:26:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:41799 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZHZA0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:26:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19092.33091.411781.10032@cargo.ozlabs.ibm.com>
Date: Wed, 26 Aug 2009 10:26:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090825220303.GA31615@elte.hu>
References: <20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
	<19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	<20090825082612.GA17692@elte.hu>
	<19091.46451.893720.573893@cargo.ozlabs.ibm.com>
	<20090825101742.GA26801@elte.hu>
	<19091.52205.222449.441072@cargo.ozlabs.ibm.com>
	<20090825135017.GA31340@elte.hu>
	<20090825213337.GX17684@mit.edu>
	<20090825220303.GA31615@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> So i think this is much ado about nothing. Testing was done, the fix 
> was applied immediately and no kitten was hurt in the process.

I agree.

I have a question though: I notice that you add cc's to patches that
get committed to the tip tree.  Do you do that manually, or is it
automated?

And I have a request: when a patch touches architecture-specific code,
could you add a cc to the maintainer of that architecture?

Paul.
