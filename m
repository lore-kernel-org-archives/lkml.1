Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbZGIPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbZGIPAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZGIPAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:00:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZGIPAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:00:11 -0400
Message-ID: <4A5605CD.6070705@redhat.com>
Date: Thu, 09 Jul 2009 10:59:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 1/5][resend] add per-zone statistics to show_free_areas()
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709170535.23BA.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090709170535.23BA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] add per-zone statistics to show_free_areas()
> 
> show_free_areas() displays only a limited amount of zone counters. This
> patch includes additional counters in the display to allow easier
> debugging. This may be especially useful if an OOM is due to running out
> of DMA memory.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
