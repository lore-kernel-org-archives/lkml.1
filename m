Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZC3Wyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZC3Wyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZC3Wy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:54:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZC3WyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:54:25 -0400
Date: Mon, 30 Mar 2009 18:52:06 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, oleg@redhat.com, adobriyan@gmail.com,
       mingo@elte.hu, torvalds@linux-foundation.org, roland@redhat.com,
       rostedt@goodmis.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090330225206.GD16170@redhat.com>
References: <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain> <20090323151400.GA3413@redhat.com> <20090323214417.GD5814@mit.edu> <20090330151844.8b4eed0f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330151844.8b4eed0f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Mar 30, 2009 at 03:18:44PM -0700, Andrew Morton wrote:
> So we need to work out what to do about utrace and I feel a need to hit
> the reset button on all this.  [...]

Thanks.

> [...]  The ftrace patch merged about as (un)successfully as one would

A new version against -tip is coming by in a few days.

- FChE
