Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbZE0Fj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbZE0Fj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZE0Fjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:39:51 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1936 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZE0Fjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:39:51 -0400
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
 linux-kernel@vger.kernel.org from all but "THE REST"
From: Joe Perches <joe@perches.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090527013303.GB8979@linux-sh.org>
References: <cover.1243131992.git.joe@perches.com>
	 <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
	 <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com>
	 <1243135358.3560.1.camel@Joe-Laptop.home>
	 <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
	 <1243139947.3560.7.camel@Joe-Laptop.home>
	 <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
	 <20090527013303.GB8979@linux-sh.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 22:38:38 -0700
Message-Id: <1243402718.27337.8.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 10:33 +0900, Paul Mundt wrote:
> On Sat, May 23, 2009 at 10:51:24PM -0600, Grant Likely wrote:
> > Do subsystem maintainers think so?  Unless they do (and tell others
> > so), I don't think it will actually happen.  Until that point, I don't
> > think the L:linux-kernel lines should be removed.
> > 
> Ultimately it should come to common sense. If you are only touching
> subsystem or architecture-specific code and it's unlikely anyone on l-k
> is going to care, or have much to add to it, then there really isn't a
> lot of point in mindlessly Cc-ing the list on every change.

And if you already know who or to what list you
want to submit a patch to, the MAINTAINERS entry
doesn't much matter.

> Conversely, if you need to read SubmittingPatches to figure out how to
> submit a patch, yes, you are probably better off CCing l-k just to be on
> the safe side. As a blanket policy though it makes no sense.

Yup.  Agree.

