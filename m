Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYGEPTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYGEPTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYGEPSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:18:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:35661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYGEPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:18:53 -0400
Date: Sat, 5 Jul 2008 08:18:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080705081840.3820f30e@infradead.org>
In-Reply-To: <20080705141335.GB20240@mit.edu>
References: <20080704192929.2c4dd4ca@infradead.org>
	<20080705141335.GB20240@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 10:13:35 -0400
Theodore Tso <tytso@mit.edu> wrote:

> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> I will make the corresponding change for ext4.  Is the "Properly
> notify block layer of sync writes" going to be pushed to mainline?  I
> can't add SWRITE_SYNC to the ext4 tree without growing a dependency to
> this patch.

you have stale bits .. it's in Mainline for like at least 24 hours
already ;=)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
