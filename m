Return-Path: <linux-kernel-owner+w=401wt.eu-S933123AbYEBKYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123AbYEBKYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbYEBKYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:24:11 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:35760 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246AbYEBKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:24:10 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@MIT.EDU>, bunk@kernel.org, arjan@infradead.org,
       torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, rostedt@goodmis.org
Subject: Re: RFC: starting a kernel-testers group for newbies
From: Andi Kleen <andi@firstfloor.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
	<20080501084919.8ac6dbdd.akpm@linux-foundation.org>
	<20080501172434.GB17365@mit.edu>
	<20080501122636.152c80db.akpm@linux-foundation.org>
Date: Fri, 02 May 2008 12:23:25 +0200
In-Reply-To: <20080501122636.152c80db.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 1 May 2008 12:26:36 -0700")
Message-ID: <87k5idf1ia.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 10:16:30.0933 (UTC) FILETIME=[972CB050:01C8AC3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> (still wants to know what we did 2-3 years ago which caused thousands of
> people to have to resort to using noapic and other apic-related boot option
> workarounds)

Forcing APIC even when the BIOS didn't support them.

-Andi


