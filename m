Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbXKFUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbXKFUCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbXKFUB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:01:28 -0500
Received: from 1wt.eu ([62.212.114.60]:3742 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759092AbXKFUBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:01:25 -0500
Date: Tue, 6 Nov 2007 21:00:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Future of Linux 2.6.22.y series
Message-ID: <20071106200024.GF1045@1wt.eu>
References: <20071105181332.GB28628@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105181332.GB28628@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 10:13:32AM -0800, Greg Kroah-Hartman wrote:
> For the last release, I stated that I thought the 2.6.22.12 release
> would be the last one in the 2.6.22.y series.  Since then, I've received
> a number of other patches that would be nice to have in the .22.y tree.
> 
> So, for a while, I'll keep the 2.6.22.y tree open, doing new releases
> every once in a while as they accumulate.  I do this, for no other than
> the selfish reason that I use it every day on my openSuSE 10.3 boxes as
> that is the kernel base that release is on :)

It certainly is one of the most valuable reasons. If all people were
"selfish" enough to contribute what they do only for themselves, we
would possibly have less out-of-tree code.

> If anyone has any objections or questions about this, please let me
> know.

Oh no, please keep it going on for as long as you want, I'll rebase my
version on it instead of 2.6.20.y ;-)

Thanks,
Willy

