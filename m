Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbYJaNkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbYJaNkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYJaNkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:40:00 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45608 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYJaNkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:40:00 -0400
Date: Fri, 31 Oct 2008 15:39:58 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Theodore Tso <tytso@mit.edu>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
In-Reply-To: <20081030142103.GA14744@mit.edu>
Message-ID: <Pine.SOC.4.64.0810311539400.26420@math.ut.ee>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081030142103.GA14744@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it's happening nightly, I assume it's because some cron job is
> going off; it would be interesting to see what was going on at that time.

It did not happen this night with BUG() in place, will see.

-- 
Meelis Roos (mroos@linux.ee)
