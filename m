Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320Ab0AMJyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0AMJyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998Ab0AMJyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:54:22 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63307 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab0AMJyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LXP/WPQUK+dDgaTHeQet2He8MR9T2/9dzK8ByCs3ZZVOr02cNV1hgs6k9v8qxZq0Cz
         97nkODHbvKfFTaBcAZJFQJOVt2PfNXlCrTvgHxzv/TJwzoOcIWkDJyRHFipc+uZgHwKS
         XqfZA/GpHCT02UPMmDP5DSlYgloa0X3gwfzSQ=
MIME-Version: 1.0
In-Reply-To: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
References: <20100113171734.B3E2.A69D9226@jp.fujitsu.com>
Date: Wed, 13 Jan 2010 18:54:20 +0900
Message-ID: <28c262361001130154x391cb112wddaaf70a6cbd03b8@mail.gmail.com>
Subject: Re: [PATCH 1/3] vmscan: get_scan_ratio cleanup
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 5:19 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> The get_scan_ratio() should have all scan-ratio related calculations.
> Thus, this patch move some calculation into get_scan_ratio.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
