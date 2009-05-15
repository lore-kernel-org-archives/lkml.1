Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbZEOLC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbZEOLC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZEOLCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:02:50 -0400
Received: from cmpxchg.org ([85.214.51.133]:40792 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbZEOLCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:02:49 -0400
Date: Fri, 15 May 2009 13:02:45 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of no swap space V4
Message-ID: <20090515110245.GA2176@cmpxchg.org>
References: <20090515103818.2c46d48a.minchan.kim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515103818.2c46d48a.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
