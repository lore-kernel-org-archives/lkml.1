Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZGPMdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZGPMdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZGPMdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:33:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:19254 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZGPMdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,411,1243839600"; 
   d="scan'208";a="165688571"
Date: Thu, 16 Jul 2009 20:33:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Message-ID: <20090716123321.GA28895@localhost>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com> <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:52:34AM +0800, KOSAKI Motohiro wrote:
> Subject: [PATCH] Rename pgmoved variable in shrink_active_list()
> 
> Currently, pgmoved variable have two meanings. it cause harder reviewing a bit.
> This patch separate it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com> 
