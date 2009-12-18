Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZLRPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZLRPNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZLRPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:13:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZLRPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:13:18 -0500
Date: Fri, 18 Dec 2009 15:12:41 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>,
       Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Re: [PATCH] scripts/checkpatch.pl: Change long line
	warning to 105 chars
Message-ID: <20091218151241.GD9334@agk-dp.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
	linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain> <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com> <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home> <m3iqc41h83.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3iqc41h83.fsf@intrepid.localdomain>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 03:37:00PM +0100, Krzysztof Halasa wrote:
> Not sure if that's long enough (maybe it is).
> 132 looks like the next "natural" number.

Well it's good that this thread has produced more examples where it's
reasonable and acceptable to exceed 80 characters.

What do people feel about files where the policy is to place all the
parameters passed into a function on the same line, regardless of its
consequent length?  

(What kicked this all off was a patch Mikulas submitted containing many
long lines, one of which hits column 264.  Personally, I dislike reading
code with lines that wrap, but using a 132-column terminal width is
fine.)

Alasdair

