Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZL2VjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZL2VjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZL2VjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:39:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZL2VjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:39:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: [Bug #14905] kernel BUG at kernel/timer.c:951!
Date: Tue, 29 Dec 2009 22:39:51 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bernard Pidoux <bernard.pidoux@upmc.fr>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.2YB.JwhOLB@chimera> <20091229183522.GB3081@del.dom.local>
In-Reply-To: <20091229183522.GB3081@del.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292239.51975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Jarek Poplawski wrote:
> On Tue, Dec 29, 2009 at 04:28:54PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14905
> > Subject		: kernel BUG at kernel/timer.c:951!
> > Submitter	: Bernard Pidoux <bernard.pidoux@upmc.fr>
> > Date		: 2009-12-19 13:38 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126122997831460&w=4
> > Handled-By	: Jarek Poplawski <jarkao2@gmail.com>
> > 
> > 
> 
> If this is what I think, then it's a "regular" bug, not a regression.

OK, dropping from the list for now.  Please let me know in case it turns out to
be something else. ;-)

Rafael
