Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYEZRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYEZRei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEZRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:34:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbYEZRe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:34:29 -0400
Date: Mon, 26 May 2008 13:05:08 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080526170508.GB4617@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	Bosko Radivojevic <bosko.radivojevic@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com> <20080522165008.GB2727@cs181133002.pp.htv.fi> <20080522151834.03f2790f@infradead.org> <20080523090940.GG2727@cs181133002.pp.htv.fi> <20080523071157.3cfdc03a@infradead.org> <20080523165055.GC28257@cs181133002.pp.htv.fi> <20080523112908.19f9413d@infradead.org> <20080523203112.GA4886@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523203112.GA4886@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:31:12PM +0300, Adrian Bunk wrote:
 > On Fri, May 23, 2008 at 11:29:08AM -0700, Arjan van de Ven wrote:
 > > On Fri, 23 May 2008 19:50:55 +0300
 > > Adrian Bunk <bunk@kernel.org> wrote:
 > > 
 > > > On Fri, May 23, 2008 at 07:11:57AM -0700, Arjan van de Ven wrote:
 > > > > On Fri, 23 May 2008 12:09:40 +0300
 > > > > Adrian Bunk <bunk@kernel.org> wrote:
 > > > > 
 > > > > > 
 > > > > > And in case anyone says "not forwarded distribution bugs aren't
 > > > > > our problem":
 > > > > > That's a nice example, since in this case a distribuion suddenly 
 > > > > > starting to agressively forwarding their bugs might contribute to
 > > > > > making the kernel better, but might also totally ruin the numbers
 > > > > > in any statistics.
 > > > > 
 > > > > Fedora gets less than 1000 bugs per release (so 6 month window).
 > > > > That's... peanuts.
 > > > 
 > > > 2000 kernel bugs per year?
 > > 
 > > it's going down; 750-ish for the last few releases
 > > 
 > > (see http://kernelslacker.livejournal.com/116718.html )
 > 
 > It's a bit suspicious that the "Total number of bugs filed across all 
 > packages" also went down by quite some amount.

The last two releases hadn't reached end-of-life yet. I just updated
that entry, with the latest numbers for F7/F8, and threw in F9 too.

      total    kernel
F7    5534     724
F8    7589     902
F9    4624     292

Given F9 has only been out a few weeks, that's quite high.  As more
people move from F7 -> F8 as F7 gets closer to end of life, the bug
count there is shifting too.
(for point of reference, F7 is on 2.6.24, F8 is about to get a .25 update,
 F9 was released with .25)

 > Are recent Fedora kernels less buggy or do less people file bugs since 
 > everyone now uses Ubuntu?

My majority of my job is still spending reading and dealing with bugzilla.
I think if there were a noticable drop-off, I'd have more time to be
sitting around eating cheetos or doing something else.  That hasn't happened.

	Dave

-- 
http://www.codemonkey.org.uk
