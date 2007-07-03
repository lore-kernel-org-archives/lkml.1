Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbXGCIuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbXGCIuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbXGCIuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:50:44 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:37308 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbXGCIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:50:43 -0400
Date: Tue, 3 Jul 2007 10:50:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070703105040.2afd2bcf@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070601123848.GH7426@kroah.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46585953.80200@imap.cc>
	<20070526090117.dda72286.akpm@linux-foundation.org>
	<465A033C.3070400@imap.cc>
	<3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
	<20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
	<465C5AF9.20601@imap.cc>
	<20070529192511.24924171@gondolin.boeblingen.de.ibm.com>
	<20070601123848.GH7426@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 05:38:48 -0700,
Greg KH <greg@kroah.com> wrote:

[Sorry for taking so long to respond, I've been offline for a month]

> Can you resend me the new patch, I seem to have lost it in this thread
> :(

Andrew has the fixup patch in his -mm lineup as
driver-core-check-return-code-of-sysfs_create_link-fix.patch. Do you
need anything else?

Cornelia
