Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZBOAFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZBOAFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZBOAFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:05:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:52196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZBOAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:05:42 -0500
Date: Sat, 14 Feb 2009 16:05:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12496] swsusp cannot find resume device (sometimes)
Message-ID: <20090214160542.1c668398@infradead.org>
In-Reply-To: <rjPbZ5GRJPO.A.6RG.6s0lJB@chimera>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
	<rjPbZ5GRJPO.A.6RG.6s0lJB@chimera>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 21:38:16 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12496
> Subject		: swsusp cannot find resume device (sometimes)
> Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> Date		: 2009-01-09 12:24 (37 days old)
> References	:
> http://marc.info/?l=linux-kernel&m=123150395731165&w=4
> Handled-By	: Arjan van de Ven <arjan@infradead.org>
> Patch		:
> http://marc.info/?l=linux-kernel&m=123156441218358&w=4
> http://marc.info/?t=123156453100002&r=1&w=4
> 
> 

it is sad that a patch for a regression that has been available for
this long still has not been merged.

Sending me email over and over again does not make the maintainers
who have the patch in their queues get off their sit-organs any
faster....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
