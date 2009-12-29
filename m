Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZL2Vwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZL2Vwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZL2Vwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:52:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZL2Vwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:52:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: [Bug #14923] Regression in 2.6.32.2: segfault on halt
Date: Tue, 29 Dec 2009 22:53:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A._IH.RnhOLB@chimera> <pan.2009.12.29.18.39.47.926000@googlemail.com>
In-Reply-To: <pan.2009.12.29.18.39.47.926000@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292253.25763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Holger Hoffstaette wrote:
> On Tue, 29 Dec 2009 16:09:59 +0100, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14923
> > Subject		: Regression in 2.6.32.2: segfault on halt
> > Submitter	: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
> > Date		: 2009-12-19 15:10 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126123574505069&w=4
> > Handled-By	: Mike Galbraith <efault@gmx.de>
> 
> Problem found, fixed by later commit as reported in:
> http://marc.info/?l=linux-kernel&m=126138815719603&w=4

Thanks, closing.

Rafael
