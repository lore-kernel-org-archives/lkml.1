Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbYFFDww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbYFFDww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYFFDwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:52:44 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40598 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbYFFDwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:52:43 -0400
Message-ID: <4848B406.3000909@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 09:20:30 +0530
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
Subject: Re: [PATCH 1/3 v2] per-task-delay-accounting: add memory reclaim
 delay
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163111.8877ecb7.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080605163111.8877ecb7.kobayashi.kk@ncos.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keika Kobayashi wrote:
> Sometimes, application responses become bad under heavy memory load.
> Applications take a bit time to reclaim memory.
> The statistics, how long memory reclaim takes, will be useful to
> measure memory usage.
> 
> This patch adds accounting memory reclaim to per-task-delay-accounting
> for accounting the time of do_try_to_free_pages().
> 

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
