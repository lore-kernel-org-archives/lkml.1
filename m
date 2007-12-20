Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXLTWXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXLTWXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765751AbXLTWWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:22:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59167 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765730AbXLTWWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:22:32 -0500
Date: Thu, 20 Dec 2007 22:08:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, apw@shadowen.org, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220220853.4f7c639c@the-village.bc.nu>
In-Reply-To: <1198188468.6183.80.camel@localhost>
References: <1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<20071220.135133.262055434.davem@davemloft.net>
	<1198188468.6183.80.camel@localhost>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe though that printk messages are not sentences but are
> logging statements.  Statements do not require full-stops.
> 
> Opinions, of course, vary.

I do not believe "opinions" are relevant here. Relevant would be cites
from respected style guides (Fowlers, Oxford Guide To Style et al.) to
show they do not need a full stop. 

I've not found one, but I am open to references.

Alan
