Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYJ1J0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYJ1J0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYJ1J0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:26:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54187 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbYJ1J0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:26:37 -0400
Date: Tue, 28 Oct 2008 09:24:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-stable@vger.kernel.org,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-ID: <20081028092449.3123fe39@lxorguk.ukuu.org.uk>
In-Reply-To: <20081028084407.GA7913@flint.arm.linux.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
	<20081027092512.9327b690.randy.dunlap@oracle.com>
	<20081027234246.ea5e3b8e.akpm@linux-foundation.org>
	<20081028084407.GA7913@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since it's a trivial documentation matter, don't we have someone
> handling such patches?  Is Rusty still the Trivial Patch Monkey?

Randy is the documentation maintainer (see MAINTAINERS)
 
Sounds like it should just go in directly not through the ARM tree
