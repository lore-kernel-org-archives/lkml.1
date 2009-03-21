Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZCUVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZCUVyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZCUVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:54:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZCUVyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:54:05 -0400
Date: Sat, 21 Mar 2009 17:51:45 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321215145.GB5262@redhat.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321143413.75ead1aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


On Sat, Mar 21, 2009 at 02:34:13PM -0700, Andrew Morton wrote:
> [...]
> It would not be good to merge a large kernel feature which kernel
> developers and testers cannot test, and regression test.

It does not.  Other kernel self-sufficient utrace clients are on their
way, and of course one was just (re)posted.

> If testing utrace against its main application requires installation
> of a complete enterprise distro from a distro [...]

This has *never* been a requirement.


- FChE
