Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0BUWVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:21:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59211 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0BUWVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:21:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #14657] perf subsystem breakage in 2.6.32-rc7
Date: Sun, 21 Feb 2010 23:22:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.KuC.fwagLB@chimera> <alpine.LFD.2.00.1002212310030.2811@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002212310030.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212322.35050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010, Thomas Gleixner wrote:
> On Sun, 21 Feb 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14657
> > Subject		: perf subsystem breakage in 2.6.32-rc7
> > Submitter	: Arjan van de Ven <arjan@infradead.org>
> > Date		: 2009-11-19 19:50 (95 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125866013419738&w=4
> 
> Can we please take that off the list? That bisect result is more than
> silly and we never got any useful information about that "problem".

OK

Rafael
