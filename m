Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbXELRYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbXELRYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbXELRYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:24:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756698AbXELRYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:24:24 -0400
Date: Sat, 12 May 2007 10:23:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070512102350.04126320.akpm@linux-foundation.org>
In-Reply-To: <1178989302.22481.185.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	<20070511132846.5ebf4437.akpm@linux-foundation.org>
	<200705112302.47726.rjw@sisk.pl>
	<200705112309.15996.rjw@sisk.pl>
	<20070511235607.83ad0eb5.akpm@linux-foundation.org>
	<1178959563.22481.126.camel@localhost.localdomain>
	<20070512020056.a24cf472.akpm@linux-foundation.org>
	<1178961489.22481.133.camel@localhost.localdomain>
	<20070512030754.90488f79.akpm@linux-foundation.org>
	<1178970253.22481.143.camel@localhost.localdomain>
	<20070512095145.0cf58a57.akpm@linux-foundation.org>
	<1178989302.22481.185.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 19:01:41 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> Can you upload a snapshot of your current queue ?

Yeah, that's super-easy.  It just happens that it all compiles
and runs at present ;)

The single-big-patch is at http://userweb.kernel.org/~akpm/tg.bz2

The broken-out queue should turn up at
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/
in a few minutes.
