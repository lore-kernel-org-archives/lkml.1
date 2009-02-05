Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbZBEBVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbZBEBVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZBEBVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:21:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZBEBVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:21:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #12591] NULL pointer dereference in blk_queue_io_stat
Date: Thu, 5 Feb 2009 02:21:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.OKF.BvYiJB@chimera> <20090204125320.GH30821@kernel.dk>
In-Reply-To: <20090204125320.GH30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050221.19693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jens Axboe wrote:
> On Wed, Feb 04 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12591
> > Subject		: NULL pointer dereference in blk_queue_io_stat
> > Submitter	: Petr Vandrovec <vandrove@vc.cvut.cz>
> > Date		: 2009-01-31 23:58 (5 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bc58ba9468d94d62c56ab9b47173583ec140b165
> > Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> 
> This one is already fixed in -git by commit
> fb8ec18c316d869271137c97320dbfd2def56569.

Thanks, closed.

Rafael
