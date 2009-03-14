Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZCNPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZCNPE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCNPEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:04:20 -0400
Received: from verein.lst.de ([213.95.11.210]:55876 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZCNPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:04:20 -0400
Date: Sat, 14 Mar 2009 16:04:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #12405] oops in __bounce_end_io_read under kvm
Message-ID: <20090314150407.GB27604@lst.de>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera> <pRIaSZpQ1ON.A.TND.CearJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pRIaSZpQ1ON.A.TND.CearJB@chimera>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 08:41:32PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12405
> Subject		: oops in __bounce_end_io_read under kvm
> Submitter	: Christoph Hellwig <hch@lst.de>
> Date		: 2008-12-26 17:36 (68 days old)
> References	: http://marc.info/?l=linux-kernel&m=123031303400676&w=4

I haven't been able to hit this anymore for a while.
