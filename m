Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZCGVbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZCGVbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZCGVbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:31:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60322 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZCGVbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:31:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #12501] build bug in eeepc-laptop.c
Date: Sat, 7 Mar 2009 22:31:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       rui.zhang@intel.com
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.nSG.-WarJB@chimera> <84144f020903040102o1ddc6ee7l31bf4cf928092773@mail.gmail.com>
In-Reply-To: <84144f020903040102o1ddc6ee7l31bf4cf928092773@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072231.30667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Pekka Enberg wrote:
> On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12501
> > Subject         : build bug in eeepc-laptop.c
> > Submitter       : Ingo Molnar <mingo@elte.hu>
> > Date            : 2009-01-14 17:25 (49 days old)
> > References      : http://lkml.org/lkml/2009/1/14/315
> 
> There's seems to be a patch for the bug here:
> 
> http://bugzilla.kernel.org/attachment.cgi?id=20341&action=view

Thanks, updated.

Rafael
