Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZL2WHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZL2WHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZL2WHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:07:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZL2WHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:07:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #14794] IP address assigned by DHCP is dropped after ~40 seconds
Date: Tue, 29 Dec 2009 23:07:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?utf-8?q?M=C3=A1rton_N=C3=A9meth?= <nm127@freemail.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.MyC.uwhOLB@chimera> <1262101463.17659.1.camel@marge.simson.net>
In-Reply-To: <1262101463.17659.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912292307.53102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, Mike Galbraith wrote:
> On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> > Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> > Submitter	: Márton Németh <nm127@freemail.hu>
> > Date		: 2009-12-13 08:59 (17 days old)
> 
> This one was a userspace bug it seems.

Thanks, closed.

Rafael
