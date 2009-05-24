Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZEXEjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZEXEjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 00:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZEXEjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 00:39:16 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1516 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZEXEjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 00:39:16 -0400
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
 linux-kernel@vger.kernel.org  from all but "THE REST"
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
References: <cover.1243131992.git.joe@perches.com>
	 <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
	 <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com>
	 <1243135358.3560.1.camel@Joe-Laptop.home>
	 <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 May 2009 21:39:07 -0700
Message-Id: <1243139947.3560.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 22:28 -0600, Grant Likely wrote:
> On Sat, May 23, 2009 at 9:22 PM, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2009-05-23 at 21:18 -0600, Grant Likely wrote:
> >> Really?  That makes the assumption that lack of an "L:" tag is
> >> equivalent to an "L:linux-kernel" tag, which IMNSHO I don't believe is
> >> true.
> > Documentation/SubmittingPatches
> > 6) Select your CC (e-mail carbon copy) list.
> > Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
> Is that actually true in practice?  At least on linuxppc-dev, very few
> patches are cc'd to lkml.  I don't remember ever being prompted to cc
> lkml on all patches, and I haven't been prompting others to do so.

Hi Grant.

I think cc:ing lkml should be the default for patches.

Having a few selected sections have lkml entries
might make people think that a section that doesn't
specifically mention lkml therefore wouldn't need to
a cc: to lkml.

Perhaps MAINTAINERS should mention that its preface
as well as having it in Documentation/SubmittingPatches?


