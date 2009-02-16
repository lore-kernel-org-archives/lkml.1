Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZBPVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZBPVMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZBPVL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:11:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57340 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZBPVLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:11:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: 2.6.29-rc5: Reported regressions from 2.6.28
Date: Mon, 16 Feb 2009 22:11:29 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <20090216072910.GA4763@ff.dom.local>
In-Reply-To: <20090216072910.GA4763@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162211.30830.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009, Jarek Poplawski wrote:
> On 14-02-2009 21:35, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.28, for which there
> > are no fixes in the mainline I know of.  If any of them have been fixed already,
> > please let me know.
> ...
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12615
> > Subject		: boot hangs while bringing up gianfar ethernet
> > Submitter	: Ira Snyder <iws@ovro.caltech.edu>
> > Date		: 2009-01-29 19:41 (17 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123325817201665&w=4
> 
> Fixed by:
> commit	8707bdd48ab705a459ac1b12014075a139d1d4f9
> gianfar: Fix boot hangs while bringing up gianfar ethernet
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8707bdd48ab705a459ac1b12014075a139d1d4f9

Thanks, closed.

Rafael
