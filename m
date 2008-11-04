Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYKDOuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYKDOuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYKDOuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:50:24 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56185 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbYKDOuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:50:23 -0500
Date: Tue, 4 Nov 2008 09:50:16 -0500
From: Theodore Tso <tytso@mit.edu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-ID: <20081104145016.GJ30291@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Meelis Roos <mroos@linux.ee>,
	Andrew Morton <akpm@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081101163829.GD8134@mit.edu> <20081101171042.GE8134@mit.edu> <200811012121.29534.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811012121.29534.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any updates on whether the patch that I've posted has solved this regression?

Thanks!!

							- Ted
