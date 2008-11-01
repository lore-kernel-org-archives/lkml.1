Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbYKARK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbYKARK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYKARKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:10:48 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39716 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbYKARKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:10:47 -0400
Date: Sat, 1 Nov 2008 13:10:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-ID: <20081101171042.GE8134@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Meelis Roos <mroos@linux.ee>,
	Andrew Morton <akpm@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081031235459.055c35d7.akpm@linux-foundation.org> <Pine.SOC.4.64.0811011058240.18925@math.ut.ee> <20081101163829.GD8134@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101163829.GD8134@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, I've opened a Bugzilla entry to track this as a 2.6.27 regression:

     http://bugzilla.kernel.org/show_bug.cgi?id=11935

							- Ted
