Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZCNSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZCNSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZCNSZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:25:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZCNSZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:25:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bug #12405] oops in __bounce_end_io_read under kvm
Date: Sat, 14 Mar 2009 19:25:00 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera> <pRIaSZpQ1ON.A.TND.CearJB@chimera> <20090314150407.GB27604@lst.de>
In-Reply-To: <20090314150407.GB27604@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141925.01318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Christoph Hellwig wrote:
> On Tue, Mar 03, 2009 at 08:41:32PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
> > Subject		: oops in __bounce_end_io_read under kvm
> > Submitter	: Christoph Hellwig <hch@lst.de>
> > Date		: 2008-12-26 17:36 (68 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4
> 
> I haven't been able to hit this anymore for a while.

Let's assume it's been fixed, then. :-)

I've closed the bug, please reopen if you see it again.

Thanks,
Rafael
