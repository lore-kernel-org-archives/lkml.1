Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbXJCEDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbXJCEDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXJCEDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:03:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55555 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXJCEC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:02:59 -0400
Date: Tue, 2 Oct 2007 21:01:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: ak@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
Message-Id: <20071002210125.85b84add.randy.dunlap@oracle.com>
In-Reply-To: <4702FEC7.3000000@garzik.org>
References: <20071003013413.GA17717@havoc.gtf.org>
	<20071002192209.09b2fbda.randy.dunlap@oracle.com>
	<4702FEC7.3000000@garzik.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 22:30:31 -0400 Jeff Garzik wrote:

> Randy Dunlap wrote:
> > On Tue, 2 Oct 2007 21:34:13 -0400 Jeff Garzik wrote:
> > 
> >> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> >> ---
> >> After having to go figure out what some of these means, I figured I
> >> would save others the trouble.
> >>
> >> Some of these are "best guess" based on a quick scan of the code, so it
> >> certainly needs a sanity review before going upstream.
> > 
> > "iommu" is listed in Documentation/x86_64/boot-options.txt
> > along with more x86_64-specific boot options.
> > A few other arches do something similar...
> 
> Ah!  Well, seeing as how we already have a provision for arch-specific 
> options in kernel-parameters.txt, and some less-obscure arch-specific 
> options can be found there, I think an argument can be made for my patch :)
> 
> Nonethless, if the maintainer disagrees, they can drop this patch I suppose.

[sorry if there be duplicates; I thought I sent this but can't find it
anywhere]


Maybe we can/should merge the doc files along with the x86 arch merge.

---
~Randy
