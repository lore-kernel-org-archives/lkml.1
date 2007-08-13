Return-Path: <linux-kernel-owner+w=401wt.eu-S965905AbXHMRx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965905AbXHMRx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974042AbXHMRp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:45:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44602 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031415AbXHMRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:45:15 -0400
Date: Mon, 13 Aug 2007 18:51:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [70/2many] MAINTAINERS - ARPD SUPPORT
Message-ID: <20070813185148.16308985@the-village.bc.nu>
In-Reply-To: <1187024659.10249.125.camel@localhost>
References: <46bff8e8.HhTQ7TBPy1zkcNfh%joe@perches.com>
	<20070813114942.04a5483c@the-village.bc.nu>
	<1187019966.10249.75.camel@localhost>
	<20070813173522.685dab9e@the-village.bc.nu>
	<1187024659.10249.125.camel@localhost>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 10:04:19 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2007-08-13 at 17:35 +0100, Alan Cox wrote:
> > I wouldn't add a pattern for this.
> 
> Back to:ARPD SUPPORT
> P:	Jonathan Layes
> L:	netdev@vger.kernel.org
> S:	Maintained
> 
> > Actually I think the entire thing is a
> > bad idea but thats another matter.
> 
> Of course it's not an end-all solution,
> but what might work better?

Working off the git tree as it shows who actually is making
changes/updating stuff recently and why which is a major clue when
tracing bugs
