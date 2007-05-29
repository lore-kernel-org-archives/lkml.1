Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbXE2RZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbXE2RZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXE2RZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:25:13 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:59602 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXE2RZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:25:11 -0400
Date: Tue, 29 May 2007 19:25:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070529192511.24924171@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <465C5AF9.20601@imap.cc>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46585953.80200@imap.cc>
	<20070526090117.dda72286.akpm@linux-foundation.org>
	<465A033C.3070400@imap.cc>
	<3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
	<20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com>
	<465C5AF9.20601@imap.cc>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 18:55:21 +0200,
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 29.05.2007 09:25 schrieb Cornelia Huck:
> > Could those folks that had trouble with this kernel check out whether
> > the following patch helps?
> 
> Yes, that patch fixes my problem.
> 
> Thanks,
> Tilman

Thanks for testing (to both of you) and again sorry for the breakage.
