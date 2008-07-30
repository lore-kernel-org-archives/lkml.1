Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYG3SF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYG3SF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYG3SFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:05:52 -0400
Received: from vena.lwn.net ([206.168.112.25]:32842 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYG3SFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:05:51 -0400
Date: Wed, 30 Jul 2008 12:05:48 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>
Subject: Re: [PATCH, RFC] A development process document
Message-ID: <20080730120548.7478917a@bike.lwn.net>
In-Reply-To: <20080730001508.9095f571.akpm@linux-foundation.org>
References: <20080729143015.0f79cf37@bike.lwn.net>
	<20080730001508.9095f571.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 00:15:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I wonder a bit whether a ./Documentation update is the best way to
> present this.  Rather than, say,
> http://www.kernel.org/read-this.html. The latter may be easier for
> you to update, and we won't have the problem of people reading
> two-year-old versions of the document.

I think LF wants to put it up somewhere; kernel.org is certainly a
possibility too.  OTOH if it's in the kernel source, others could update it
too.  I've always really liked the way stuff in Documentation/ stays
current... 

> > +The Linux kernel, at over 6 million lines of code and 2000 active
> > +contributors,
> 
> I suspect the "2000 active developers" is a bit hypey.  Is a 0.5
> patch/annum developer "active"?

I was going with 1.0/year as a working number.  The period v2.6.22..v2.6.26
(July 8, 2007 to July 13, 2008) had 2294 distinct contributors.  About 1000
of those were a single patch.  If we say that >= 2.0 is active, then the
number goes to 1200.  I could just say "over 1000" and be happy with that,
I guess.
 
> Also: if the code is kept out-of-tree then there is a risk that
> someone else's similar feature will be merged in mainline.  

Good point, I'll add that.  Everything else you pointed out is good too,
consider it all added.  After LWN comes out, anyway.  Thanks for taking the
time to read through it all.

jon
