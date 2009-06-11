Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbZFKCXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbZFKCXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbZFKCXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:23:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZFKCXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:23:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.31 -mm merge plans
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
Message-Id: <20090611112031.5918.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 11:23:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
> vmscan-drop-pf_swapwrite-from-zone_reclaim.patch
> vmscan-zone_reclaim-use-may_swap.patch

Could you please hold those zone-reclaim related patches a while?
zone reclaim is under disccusion with Mel and Wu now.



