Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZKQWYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZKQWYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZKQWYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:24:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38574 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbZKQWYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:24:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #14372] ath5k wireless not working after suspend-resume - eeepc
Date: Tue, 17 Nov 2009 23:26:17 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.zf.FUdALB@chimera> <b637ec0b0911162359y188f0829if277467229b095b3@mail.gmail.com>
In-Reply-To: <b637ec0b0911162359y188f0829if277467229b095b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911172326.17745.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009, Fabio Comolli wrote:
> The offending commit got reverted in -rc7, therefore this regression is solved.
> 
> On Mon, Nov 16, 2009 at 11:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14372
> > Subject         : ath5k wireless not working after suspend-resume - eeepc
> > Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> > Date            : 2009-10-03 15:36 (45 days old)
> > References      : http://lkml.org/lkml/2009/10/3/91

Thanks, closed.

Rafael
