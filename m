Return-Path: <linux-kernel-owner+w=401wt.eu-S1751018AbZGPEAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbZGPEAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZGPEAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:00:49 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:33775 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZGPEAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bXsc/ksNDodopOO8UDaRSipoyH7OdWyk2mLKBpknq7RQo07EosnAXIOVP04BAbCdjh
         hOxNVcRySrM2+m47xPvW8lZ79hGisLgpFQ6/tP7bvdUghoD+30zkjGRMYKgUwuiMDA5S
         Ba0LsEf2PYiCIwS+aQlIh+GyTeCDOJxwxbeMs=
MIME-Version: 1.0
In-Reply-To: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
	 <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
Date: Thu, 16 Jul 2009 13:00:46 +0900
Message-ID: <28c262360907152100q4e570c18s19db0845411e352a@mail.gmail.com>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.


On Thu, Jul 16, 2009 at 9:52 AM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] Rename pgmoved variable in shrink_active_list()
>
> Currently, pgmoved variable have two meanings. it cause harder reviewing a bit.
> This patch separate it.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
