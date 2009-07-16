Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZGPCIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZGPCIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZGPCIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:08:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbZGPCIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:08:21 -0400
Message-ID: <4A5E8B84.4040401@redhat.com>
Date: Wed, 15 Jul 2009 22:08:04 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com> <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] Rename pgmoved variable in shrink_active_list()
> 
> Currently, pgmoved variable have two meanings. it cause harder reviewing a bit.
> This patch separate it.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
