Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbYEAT2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbYEAT2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759780AbYEAT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:27:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759693AbYEAT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:27:56 -0400
Date: Thu, 1 May 2008 12:26:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: bunk@kernel.org, arjan@infradead.org, torvalds@linux-foundation.org,
       rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, rostedt@goodmis.org
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-Id: <20080501122636.152c80db.akpm@linux-foundation.org>
In-Reply-To: <20080501172434.GB17365@mit.edu>
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
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 13:24:34 -0400
Theodore Tso <tytso@MIT.EDU> wrote:

> ... and maybe we can't solve hardware bugs. 

Many, many of these are regressions.  If old-linux works on that
hardware then new-linux can too.

(still wants to know what we did 2-3 years ago which caused thousands of
people to have to resort to using noapic and other apic-related boot option
workarounds)

