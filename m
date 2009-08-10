Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZHJOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZHJOay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZHJOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:30:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50226 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000AbZHJOaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:30:52 -0400
Subject: Re: 2.6.31-rc5-git5: Reported regressions from 2.6.30
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 09:30:43 -0500
Message-Id: <1249914643.4089.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-09 at 22:36 +0200, Rafael J. Wysocki wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13716
> Subject         : The AIC-7892P controller does not work any more
> Submitter       : Andrej Podzimek <andrej@podzimek.org>
> Date            : 2009-07-05 19:23 (36 days old)

This one sounds like an IRQ routing error, so probably ACPI, but we've
been totally unsuccessful at getting any further information out of the
submitter.  Use your own time judgement on this, but if he hasn't been
responding to you either for 36 days, I'd suggest closing this as
unresponsive.

James


