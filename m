Return-Path: <linux-kernel-owner+w=401wt.eu-S965771AbXBTAoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965771AbXBTAoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965777AbXBTAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:44:15 -0500
Received: from holomorphy.com ([66.93.40.71]:56927 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771AbXBTAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:44:14 -0500
Date: Mon, 19 Feb 2007 16:40:57 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] proper prototype for hugetlb_get_unmapped_area()
Message-ID: <20070220004057.GN21484@holomorphy.com>
References: <20070220000634.GC13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000634.GC13958@stusta.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 01:06:34AM +0100, Adrian Bunk wrote:
> This patch adds a proper prototype for hugetlb_get_unmapped_area() in 
> include/linux/hugetlb.h.
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> This patch was already sent on:
> - 25 Nov 2006
>  fs/hugetlbfs/inode.c    |    5 +----
>  include/linux/hugetlb.h |    7 +++++++
>  2 files changed, 8 insertions(+), 4 deletions(-)

I don't see why not.

Acked-by: William Irwin <wli@holomorphy.com>


-- wli
