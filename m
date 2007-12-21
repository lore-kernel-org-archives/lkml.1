Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbXLUKbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbXLUKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXLUKbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:31:39 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48233 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750740AbXLUKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:31:38 -0500
Date: Fri, 21 Dec 2007 10:21:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: Andy Whitcroft <apw@shadowen.org>, Joe Perches <joe@perches.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071221102122.1e5f7d60@the-village.bc.nu>
In-Reply-To: <200712210243.35240.elendil@planet.nl>
References: <474E6BD0.20103@cn.fujitsu.com>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<200712210243.35240.elendil@planet.nl>
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

> I'm afraid that I completely and utterly disagree. Kernel messages are _not_ 
> sentences. The vast majority is not well-formed and does not contain any of 
> the elements that are required for a proper sentence.

This wants fixing.

> The most kernel messages can be compared to is a rather diverse and sloppy 
> enumeration.

We fix sloppy things outside quotes we should fix them within quotes. A
lot of stuff is sentences or fully formed clauses that deserve
punctuating. I agree entirely that this is not always the case.

