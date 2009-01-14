Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZANUYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZANUYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZANUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:24:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZANUYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:24:12 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114121521.197dfc5e.akpm@linux-foundation.org>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 21:24:07 +0100
Message-Id: <1231964647.14825.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:15 -0800, Andrew Morton wrote:
> On Sun, 11 Jan 2009 15:43:05 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Please pull the latest sched-fixes-for-linus git tree
> 
> In http://bugzilla.kernel.org/show_bug.cgi?id=12309 the reporters have
> identified what appears to be a sched-related performance regression. 
> A fairly long-term one - post-2.6.18, perhaps.
> 
> Testcase code has been added today.  Could someone please take a look
> sometime?

There appear to be two different bug reports in there. One about iowait,
and one I'm not quite sure what it is about.

The second thing shows some numbers and a test case, but I fail to see
what the problem is with it.

