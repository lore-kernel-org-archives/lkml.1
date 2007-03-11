Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXCKH0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXCKH0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 03:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXCKH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 03:26:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXCKH0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 03:26:17 -0400
Date: Sat, 10 Mar 2007 23:26:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org, twoller@crystal.cirrus.com
Subject: Re: [PATCH] CIRRUS: Delete unused header file.
Message-Id: <20070310232610.dda68aff.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101725550.28973@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703101725550.28973@CPE00045a9c397f-CM001225dbafb6>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 10 Mar 2007 17:27:44 -0500 (EST) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> 
>   Delete apparently unused header file
> sound/pci/cs46xx/imgs/cwcemb80.h.
> 

That patch series was rather a mess

- Multiple patches with the same Subject: (I might have lost some as a result)

- Several patches which tried to remove the same header file

- Several patches which simply didn't apply

- Inconsisent changelogging, inconsistent titling

- Lack of sequence numbering (again, contributes to possible patch loss)

- Useless indenting in changleog text which I have to edit away.

We have good tools (ie: quilt) which make this sort of thing nice and easy
to get right - please use them.

I didn't check that these headers are indeed unused.  I hope you got that
minor part right..

