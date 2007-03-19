Return-Path: <linux-kernel-owner+w=401wt.eu-S1030317AbXCSQLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030317AbXCSQLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXCSQLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:11:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27755 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbXCSQLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:11:11 -0400
Date: Mon, 19 Mar 2007 09:06:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2/6] 2.6.21-rc4: known regressions
Message-Id: <20070319090657.3142b8a8.randy.dunlap@oracle.com>
In-Reply-To: <20070318184915.GV752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070318184915.GV752@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 19:49:15 +0100 Adrian Bunk wrote:

> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : x86_64: boot hangs unless CONFIG_PCIEPORTBUS=n and acpi=off
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8162
> Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
> Status     : unknown

Bug is rejected due to user error.
This seems to be a netconsole hang, not ACPI.

---
~Randy
