Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYFFEQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYFFEQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYFFEQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:16:34 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44413 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYFFEQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:16:34 -0400
Message-ID: <4848B9B7.2000208@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 09:44:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nagar@watson.ibm.com, balbir@in.ibm.com,
       sekharan@us.ibm.com, kosaki.motohiro@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/3 v2] per-task-delay-accounting: update document and
 getdelays.c for memory reclaim
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163338.8880eb7f.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605163338.8880eb7f.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi wrote:
> Update document and make getdelays.c show delay accounting for memory reclaim.
> 
> For making a distinction between "swapping in pages" and "memory reclaim"
> in getdelays.c, MEM is changed to SWAP.
> 
> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
