Return-Path: <linux-kernel-owner+w=401wt.eu-S1030902AbXDNAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030902AbXDNAAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030903AbXDNAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:00:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58847 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030902AbXDNAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:00:54 -0400
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070413223017.GA8961@elte.hu>
References: <20070413202100.GA9957@elte.hu>
	 <1176502546.3129.79.camel@imap.mvista.com>  <20070413223017.GA8961@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 16:59:44 -0700
Message-Id: <1176508785.3129.89.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


One other thing, what happens in the case of slow, frequency changing,
are/or inaccurate clocks .. Is the old sched_clock behavior still
tolerated?

Daniel 

