Return-Path: <linux-kernel-owner+w=401wt.eu-S937405AbXGLANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937405AbXGLANg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937078AbXGLAE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:04:27 -0400
Received: from www.osadl.org ([213.239.205.134]:39475 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937186AbXGLAEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:04:25 -0400
Subject: Re: generic clockevents/ (hr)time(r) patches was Re: -mm merge
	plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Stable Team <stable@kernel.org>
In-Reply-To: <20070711165751.b703f003.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <1184195008.12353.182.camel@chaos>
	 <20070711165751.b703f003.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 02:04:22 +0200
Message-Id: <1184198662.12353.201.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Wed, 2007-07-11 at 16:57 -0700, Andrew Morton wrote:
> They all look pretty innocuous to me.
> 
> Could you please take a second look, decide if any of them should also be
> in 2.6.22.x and let me know?

i386-hpet-check-if-the-counter-works.patch
pcspkr-use-the-global-pit-lock.patch

are the only candidates.

	tglx


