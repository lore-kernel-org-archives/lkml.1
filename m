Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000Ab0AKTq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0AKTq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915Ab0AKTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:46:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab0AKTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:46:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
Date: Mon, 11 Jan 2010 20:46:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.XRD.NilSLB@chimera> <20100110152037.1d59d7cd@infradead.org>
In-Reply-To: <20100110152037.1d59d7cd@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112046.49212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Arjan van de Ven wrote:
> On Sun, 10 Jan 2010 23:56:13 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
> > Subject		: perf subsystem breakage in 2.6.32-rc7
> > Submitter	: Arjan van de Ven <arjan@infradead.org>
> > Date		: 2009-11-19 19:50 (53 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=125866013419738&w=4
> 
> 
> patch available in the bugzilla, and also in
> http://patchwork.kernel.org/patch/71962/

That's in http://bugzilla.kernel.org/show_bug.cgi?id=15040 .

Are they the same bug in fact?

Rafael
