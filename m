Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYELTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYELTXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYELTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:23:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYELTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:23:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10615] Oops with strace_test
Date: Mon, 12 May 2008 21:23:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.sAB.3w1JIB@chimera> <alpine.LFD.1.10.0805120912070.3514@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805120912070.3514@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122123.27477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Thomas Gleixner wrote:
> On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10615
> > Subject		: Oops with strace_test
> > Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> > Date		: 2008-04-30 14:12 (12 days old)
> > References	: http://lkml.org/lkml/2008/4/30/162
> > Handled-By	: Suresh Siddha <suresh.b.siddha@intel.com>
> > Patch		: http://lkml.org/lkml/2008/5/7/225
> 
> fixes by: fd3c3ed5d1e3ceb37635cbe6d220ab94aae0781d

Thanks, closed.

Rafael
