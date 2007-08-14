Return-Path: <linux-kernel-owner+w=401wt.eu-S937449AbXHNAvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937449AbXHNAvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 20:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbXHNAuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 20:50:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3919 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbXHNAut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 20:50:49 -0400
Subject: Re: [PATCH] [464/2many] MAINTAINERS - SUPERH (sh)
From: Joe Perches <joe@perches.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxsh-shmedia-dev@lists.sourceforge.net
In-Reply-To: <20070814004347.GA633@linux-sh.org>
References: <46bffc05.Zi+AgReNUMWozyrG%joe@perches.com>
	 <46bffc03.4E2RshjUw+dyxP1/%joe@perches.com>
	 <20070814004347.GA633@linux-sh.org>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 17:50:07 -0700
Message-Id: <1187052607.10249.347.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 09:43 +0900, Paul Mundt wrote:
> On Sun, Aug 12, 2007 at 11:36:51PM -0700, joe@perches.com wrote:
> I suppose you meant include/ here?

Yes.  Thanks.  I've replace them with this in my tree.

SUPERH (sh)
P:	Paul Mundt
M:	lethal@linux-sh.org
L:	linuxsh-dev@lists.sourceforge.net (subscribers-only)
W:	http://www.linux-sh.org
S:	Maintained
F:	arch/sh/
F:	include/asm-sh/

SUPERH64 (sh64)
P:	Paul Mundt
M:	lethal@linux-sh.org
L:	linuxsh-shmedia-dev@lists.sourceforge.net
W:	http://www.linux-sh.org
S:	Maintained
F:	arch/sh64/
F:	include/asm-sh64/

> The more pressing question that comes to mind is what the point of this
> is? Architecture related drivers and things of that nature fall under
> this also, as most folks don't create a separate entry for every trivial
> driver. Are you intending to have a long list of individual drivers here
> that your script can parse?

If there are separate maintainers, sure.
Look at drivers/foo for instance.

> Is there actually a problem with people just opening up MAINTAINERS in a
> text file? Surely this is not such a non-intuitive thing, there are
> already keywords there you can grep for.

It's an automation problem.  It's just for CC's.

cheers,  Joe

