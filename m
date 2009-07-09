Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZGIU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZGIU5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZGIU5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:57:14 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:41073 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbZGIU5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:57:13 -0400
Message-ID: <4A5659A0.2030202@davidnewall.com>
Date: Fri, 10 Jul 2009 06:27:04 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <19028.31088.400461.939917@samba.org> <20090708130256.40957c3f@lxorguk.ukuu.org.uk> <19028.39145.180869.603673@samba.org> <20090708142510.5068b4c3@lxorguk.ukuu.org.uk> <19029.17896.769106.375379@samba.org> <20090709104228.7821e2f0@lxorguk.ukuu.org.uk> <1247147981.3898.15.camel@mulgrave.site> <20090709151009.07b2508b@lxorguk.ukuu.org.uk> <20090709152541.GA6334@mit.edu> <20090709171501.GA2991@infradead.org>
In-Reply-To: <20090709171501.GA2991@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> If someone really wants a patch to corrupt their filesystems they know
> where to find it.
>   

No need for pettiness. Andrew's already intimated that he's still
working the patch, and he's a very clever lad and knows if it corrupts
it needs more work.

What I don't understand is how anybody could be satisfied with the
status quo. We cannot leave vfat unchanged, for that will perpetuate a
pool of victims to be sued, and Linux loses credibility every time that
happens. Something *must* change.

What is especially attractive about Andrew's position (he said this more
eloquently than me) is that developing a solution to avoid the patent
will impact Microsoft revenues; and that will be most instructive to
them. That's almost sufficient reason by itself!
