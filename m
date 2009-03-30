Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZC3W1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZC3W1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZC3W1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:27:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZC3W1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:27:35 -0400
Date: Mon, 30 Mar 2009 15:18:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: oleg@redhat.com, adobriyan@gmail.com, mingo@elte.hu,
       torvalds@linux-foundation.org, fche@redhat.com, roland@redhat.com,
       rostedt@goodmis.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-Id: <20090330151844.8b4eed0f.akpm@linux-foundation.org>
In-Reply-To: <20090323214417.GD5814@mit.edu>
References: <20090321041954.72b99e69.akpm@linux-foundation.org>
	<20090321115141.GA3566@redhat.com>
	<20090321050422.d1d99eec.akpm@linux-foundation.org>
	<20090321154501.GA2707@elte.hu>
	<20090321143413.75ead1aa.akpm@linux-foundation.org>
	<20090321215145.GB5262@redhat.com>
	<alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
	<20090322123749.GF19826@elte.hu>
	<20090323134813.GA18219@x200.localdomain>
	<20090323151400.GA3413@redhat.com>
	<20090323214417.GD5814@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So we need to work out what to do about utrace and I feel a need to hit
the reset button on all this.  Largely because I've forgotten
everything and it was all confusing anyway.

Could those who object to utrace please pipe up and summarise their
reasons?


Just to kick the can down the road a bit I merged the first two
patches.  The ftrace patch merged about as (un)successfully as one would
expect.


