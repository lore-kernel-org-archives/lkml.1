Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZEOBrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZEOBrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZEOBqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:46:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37290 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbZEOBqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:46:51 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of no swap space V4
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <4A0CC951.6070003@redhat.com>
References: <20090515103818.2c46d48a.minchan.kim@gmail.com> <4A0CC951.6070003@redhat.com>
Message-Id: <20090515104629.87ED.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 15 May 2009 10:46:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Minchan Kim wrote:
> 
> > This patch prevents unnecessary deactivation of anon lru pages.
> > But, it doesn't prevent aging of anon pages to swap out.
> 
> >  Signed-off-by: barrios <minchan.kim@gmail.com>
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>

 Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



