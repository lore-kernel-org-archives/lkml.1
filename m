Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbZL3VxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbZL3VxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZL3VxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:53:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZL3VxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:53:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #14940] cfq-iosched: tiobench regression
Date: Wed, 30 Dec 2009 22:53:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.1VG.EnhOLB@chimera> <20091230091818.GW4489@kernel.dk>
In-Reply-To: <20091230091818.GW4489@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302253.53285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, Jens Axboe wrote:
> On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14940
> > Subject		: cfq-iosched: tiobench regression
> > Submitter	: Shaohua Li <shaohua.li@intel.com>
> > Date		: 2009-12-24 0:55 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126161612401994&w=4
> 
> I don't think this should be labelled as a regression. It was already
> known that we'd have less throughput for the many clients cases, it was
> a trade off that was made to improve latencies.

OK, I've closed it as "documented".

Rafael
