Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbYELTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbYELTYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYELTYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:24:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYELTYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:24:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10623] k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
Date: Mon, 12 May 2008 21:24:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.Sh.ow1JIB@chimera> <alpine.LFD.1.10.0805120915550.3514@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805120915550.3514@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122124.38321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Thomas Gleixner wrote:
> On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10623
> > Subject		: k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
> > Submitter	: Jeff Garzik <jeff@garzik.org>
> > Date		: 2008-05-04 07:28 (8 days old)
> > References	: http://lkml.org/lkml/2008/5/4/78
> > Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> fixed by: 0646153921892cc7a81320a6920beaca06b3e9f0

This one has been closed already.

Thanks,
Rafael
