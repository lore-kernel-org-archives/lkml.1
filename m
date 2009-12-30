Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZL3LRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZL3LRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 06:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZL3LRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 06:17:47 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42208 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZL3LRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 06:17:47 -0500
Date: Wed, 30 Dec 2009 12:17:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
Message-ID: <20091230111745.GC4489@kernel.dk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.Zg.inhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NJVdobuNFNK.A.Zg.inhOLB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14887
> Subject		: suspend doesn't work on X200s
> Submitter	: Andrew Lutomirski <luto@mit.edu>
> Date		: 2009-12-22 0:45 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=126144274102396&w=4

Works fine for me on an x200s. The only issue I seem to have is that
sometimes it suspends immediately upon resume again, presumably the lid
close event is re-triggered (or something to that extent). Apart from
that, 2.6.32 and current -git works fine for me.

-- 
Jens Axboe

