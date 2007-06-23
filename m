Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXFWR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXFWR6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFWR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:57:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbXFWR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:57:56 -0400
Date: Sat, 23 Jun 2007 10:56:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070623105645.ad4dbace.akpm@linux-foundation.org>
In-Reply-To: <20070623104303.a186c5a8.randy.dunlap@oracle.com>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 10:43:03 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > NAK.
> 
> Sorry I slept thru another wonderful festival on LKML.

That's probably the best strategy.

> You don't have the authority to NAK the patch.

Yeah.  nak to naks.

> OTOH, you also didn't supply a patch.  If you do this, I'll be
> glad to consider it.  If I can read it, that is.

Yes, I plan on merging that patch as-is.  If it was a compulsory part of
kbuild then that would be a problem but as some optional tool I don't think
that a bashism matters much.  Someone can fix it sometime should they feel
so motivated.

