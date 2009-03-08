Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZCHD7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZCHD7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZCHD66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:58:58 -0500
Received: from cmpxchg.org ([85.214.51.133]:49185 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZCHD65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:58:57 -0500
Date: Sun, 8 Mar 2009 04:58:40 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       rui.zhang@intel.com
Subject: Re: [Bug #12501] build bug in eeepc-laptop.c
Message-ID: <20090308035840.GA5802@cmpxchg.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.nSG.-WarJB@chimera> <84144f020903040102o1ddc6ee7l31bf4cf928092773@mail.gmail.com> <200903072231.30667.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903072231.30667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:31:30PM +0100, Rafael J. Wysocki wrote:
> On Wednesday 04 March 2009, Pekka Enberg wrote:
> > On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12501
> > > Subject         : build bug in eeepc-laptop.c
> > > Submitter       : Ingo Molnar <mingo@elte.hu>
> > > Date            : 2009-01-14 17:25 (49 days old)
> > > References      : http://lkml.org/lkml/2009/1/14/315
> > 
> > There's seems to be a patch for the bug here:
> > 
> > http://bugzilla.kernel.org/attachment.cgi?id=20341&action=view
> 
> Thanks, updated.

This fix is upstream: 3a5093ee6728c8cbe9c039e685fc1fca8f965048
