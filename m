Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228Ab0AKXIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0AKXIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856Ab0AKXIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:08:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0AKXIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:08:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [Bug #14948] EHCI resume sysfs duplicates
Date: Tue, 12 Jan 2010 00:08:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <201001112106.06787.rjw@sisk.pl> <20100111224159.GA9945@liondog.tnic>
In-Reply-To: <20100111224159.GA9945@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001120008.24238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Borislav Petkov wrote:
> On Mon, Jan 11, 2010 at 09:06:06PM +0100, Rafael J. Wysocki wrote:
> > On Monday 11 January 2010, Borislav Petkov wrote:
> > > On Sun, Jan 10, 2010 at 11:32:55PM +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14948
> > > > Subject		: EHCI resume sysfs duplicates
> > > > Submitter	: Borislav Petkov <petkovbb@googlemail.com>
> > > > Date		: 2009-12-26 9:36 (16 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=126182020615709&w=4
> > > 
> > > Preliminary and tested fix is at LKML-Reference: <20100105220829.GA31569@xanatos>
> > 
> > Sorry, I don't know how to resolve that.
> 
> Sorry about that. One way to resolve it would be:
> 
> http://marc.info/?i=<LKML-Reference>, i.e.
> 
> http://marc.info/?i=20100105220829.GA31569@xanatos
> 
> for example, which should get rewritten to
> 
> http://marc.info/?l=linux-usb&m=126272933202894

Thanks, this works.

Bug entry updated.

Rafael
