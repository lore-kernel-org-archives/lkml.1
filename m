Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZGGDDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZGGDDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZGGDDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:03:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35078 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZGGDDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:03:14 -0400
Message-ID: <4A52BAD2.6010702@redhat.com>
Date: Mon, 06 Jul 2009 23:02:42 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop>	<20090707090509.0C60.A69D9226@jp.fujitsu.com>	<20090707101855.0C63.A69D9226@jp.fujitsu.com> <20090707104806.6706ac4a.minchan.kim@barrios-desktop>
In-Reply-To: <20090707104806.6706ac4a.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> It looks good to me. 
> Thanks for your effort. I added my review sign. :)
> 
> Let remain one side note. 
> This accounting feature results from direct reclaim bomb. 
> If we prevent direct reclaim bomb, I think this feature can be removed. 
> 
> As I know, Rik or Wu is making patch for throttling direct reclaim. 

My plan is to build the patch on top of these patches,
so I'm waiting for them to settle :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
