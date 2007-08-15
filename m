Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbXHOI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbXHOI1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXHOI1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:27:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895AbXHOI1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:27:10 -0400
Date: Wed, 15 Aug 2007 09:33:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
Message-ID: <20070815093344.48d70c72@the-village.bc.nu>
In-Reply-To: <46C2B4FE.3080703@s5r6.in-berlin.de>
References: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
	<20070813114942.04a5483c@the-village.bc.nu>
	<1187019966.10249.75.camel@localhost>
	<20070813173522.685dab9e@the-village.bc.nu>
	<1187024659.10249.125.camel@localhost>
	<20070813185148.16308985@the-village.bc.nu>
	<46C2B4FE.3080703@s5r6.in-berlin.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 10:10:38 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Alan Cox wrote:
> >> > Actually I think the entire thing is a
> >> > bad idea but thats another matter.
> 
> > Working off the git tree as it shows who actually is making
> > changes/updating stuff recently and why which is a major clue when
> > tracing bugs
> 
> Adrian Bunk wrote in http://lkml.org/lkml/2007/6/30/107 :
> | I don't see how git could tell you to Cc net patches to
> | netdev@vger.kernel.org.
> 
> Ditto with problem reports.
> 
> For example, Cc'ing linux1394-devel on FireWire topics is a lot more
> important than Cc'ing me.

Tools question. And even if you need to keep a simple set of mappings by
hand for mailing list/files thats a fairly small set of patterns
