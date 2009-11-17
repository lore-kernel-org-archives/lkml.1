Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZKQJDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZKQJDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZKQJDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:03:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:55423 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbZKQJDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:03:32 -0500
Subject: Re: [Bug #14355] USB serial regression after 2.6.31.1 with Huawei
 E169 GSM modem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Ben Efros <ben@pc-doctor.com>
In-Reply-To: <200911170012.24914.rjw@sisk.pl>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.2k.LUdALB@chimera> <200911170005.27342.oliver@neukum.org>
	 <200911170012.24914.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 20:02:47 +1100
Message-ID: <1258448567.2140.564.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 00:12 +0100, Rafael J. Wysocki wrote:
> On Tuesday 17 November 2009, Oliver Neukum wrote:
> > Am Montag, 16. November 2009 23:37:39 schrieb Rafael J. Wysocki:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14355
> > > Subject		: USB serial regression after 2.6.31.1 with Huawei E169 GSM modem
> > > Submitter	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Date		: 2009-10-10 03:07 (38 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125513456327542&w=4
> > 
> > Benjamin has fixed this bug.
> 
> Thanks, closed.
> 

I asked Greg to re-open for a while to track other issues with
various Huawei modems. However, it appears that most of them would
be tricky to workaround in the kernel and are fixed by FW updates
(though updating those modem FW can be non trivial).

I'll leave it open for a little while see how things go on the
corresponding ubuntu bug, and if things settle, we can then close it,
in the meantime, you can remove it from your list of regressions.

Cheers,
Ben.


