Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXGQO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXGQO6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXGQO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:58:44 -0400
Received: from www.osadl.org ([213.239.205.134]:60961 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751469AbXGQO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:58:43 -0400
Subject: Re: [patch-mm 01/33] clockevents: Remove unused inline function
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200707171433.14056.ak@suse.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
	 <20070715155540.679507835@inhelltoy.tec.linutronix.de>
	 <200707171433.14056.ak@suse.de>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 16:58:41 +0200
Message-Id: <1184684321.12353.431.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 14:33 +0200, Andi Kleen wrote:
> > -static inline void clockevents_resume_events(void) { }
> >  #define clockevents_notify(reason, arg) do { } while (0)
> 
> 
> Unrelated. Surely you can just send? 

Sure.

	tglx


