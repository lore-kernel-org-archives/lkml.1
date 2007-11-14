Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbXKNTi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbXKNTi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763587AbXKNThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:37:54 -0500
Received: from sceptre.pobox.com ([207.106.133.20]:55760 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799AbXKNThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:37:53 -0500
Date: Wed, 14 Nov 2007 13:37:33 -0600
From: Nathan Lynch <ntl@pobox.com>
To: "B. N. Poornima" <poornima@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       ppc64 dev list <linuxppc64-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, roland@topspin.com
Subject: Re: [PATCH] prom_find_machine_type typo breaks pSeries lpar boot
Message-ID: <20071114193733.GK26313@localdomain>
References: <374360000.1117810369@[10.10.2.4]> <52is0vwd49.fsf@topspin.com> <20050603182725.GB11355@otto> <52vf4vuum5.fsf@topspin.com> <20050603192525.GC11355@otto> <1117839500.31082.188.camel@gaston> <473AE9BE.8070001@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473AE9BE.8070001@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

B. N. Poornima wrote:
> >On Fri, 2005-06-03 at 14:25 -0500, Nathan Lynch wrote:
> >  
> >>Typo in prom_find_machine_type from Ben's recent patch "ppc64: Fix
> >>result code handling in prom_init" prevents pSeries LPAR systems from
> >>booting.
> >>
>
> Hello,
> Same typo has creped in again from 2.6.17 kernel onwards and causing 
> open firmware exception in pSeries systems.

Looking at the current code, I don't see how this analysis could be
correct.

> The patch that is provided solves the problem.

Which patch?  Did you forget to include it?

It would be best if you sent your problem report and any patches to
linuxppc-dev@ozlabs.org.  linuxppc64-dev is dead.

Thanks.
