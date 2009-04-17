Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbZDQVWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbZDQVWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDQVWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:22:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZDQVWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:22:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #13113] tiobench read 50% regression with 2.6.30-rc1
Date: Fri, 17 Apr 2009 23:22:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.szH.Pw85JB@chimera> <20090417062951.GA4593@kernel.dk>
In-Reply-To: <20090417062951.GA4593@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172322.23638.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Jens Axboe wrote:
> On Thu, Apr 16 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13113
> > Subject		: tiobench read 50% regression with 2.6.30-rc1
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2009-04-09 8:29 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123926576802992&w=4
> > Handled-By	: Jens Axboe <jens.axboe@oracle.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123971130800697&w=4
> 
> It's fixed by d6ceb25e8d8bccf826848c2621a50d02c0a7f4ae, which is already
> merged.

Thanks, closed.

Rafael
