Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbYJ1R61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbYJ1R61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ1R6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:58:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24593 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ1R6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:58:18 -0400
Date: Tue, 28 Oct 2008 10:56:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-stable@vger.kernel.org,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-Id: <20081028105600.5c7b8b19.randy.dunlap@oracle.com>
In-Reply-To: <20081028092449.3123fe39@lxorguk.ukuu.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz>
	<20081015101747.GB28824@atrey.karlin.mff.cuni.cz>
	<20081015113923.GA21756@flint.arm.linux.org.uk>
	<200810250001.04835.rjw@sisk.pl>
	<20081026184108.GB1847@ucw.cz>
	<20081027092512.9327b690.randy.dunlap@oracle.com>
	<20081027234246.ea5e3b8e.akpm@linux-foundation.org>
	<20081028084407.GA7913@flint.arm.linux.org.uk>
	<20081028092449.3123fe39@lxorguk.ukuu.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:24:49 +0000 Alan Cox wrote:

> > Since it's a trivial documentation matter, don't we have someone
> > handling such patches?  Is Rusty still the Trivial Patch Monkey?

No, Jesper Juhl is (see MAINTAINTERS file).


> Randy is the documentation maintainer (see MAINTAINERS)

Yes, mostly for Documentation/...


> Sounds like it should just go in directly not through the ARM tree

whatever.

---
~Randy
