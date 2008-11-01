Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYKAI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYKAI7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYKAI7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 04:59:14 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50292 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYKAI7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 04:59:13 -0400
Date: Sat, 1 Nov 2008 10:59:11 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: ext3 __log_wait_for_space: no transactions
In-Reply-To: <20081031235459.055c35d7.akpm@linux-foundation.org>
Message-ID: <Pine.SOC.4.64.0811011058240.18925@math.ut.ee>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee>
 <20081031235459.055c35d7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > __log_wait_for_space: no transactions
> > Aborting journal on device sda3.
> > ext3_abort called.
> > EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> > Remounting filesystem read-only
> 
> ug.  Was 2.6.27 OK?

Yes, no known problems and it ran from 2.6.27 release until sometime 
between 28-rc1 and 28-rc2 without problems.

-- 
Meelis Roos (mroos@linux.ee)
