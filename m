Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbXGJKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbXGJKQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXGJKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:16:09 -0400
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:44395 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757804AbXGJKQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:16:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org
Subject: Re: -mm merge plans for 2.6.23
Date: Tue, 10 Jul 2007 20:15:43 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707102015.44004.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 18:31, Andrew Morton wrote:
> When replying, please rewrite the subject suitably and try to Cc: the
> appropriate developer(s).

~swap prefetch

Nick's only remaining issue which I could remotely identify was to make it 
cpuset aware:
http://marc.info/?l=linux-mm&m=117875557014098&w=2
as discussed with Paul Jackson it was cpuset aware:
http://marc.info/?l=linux-mm&m=117895463120843&w=2

I fixed all bugs I could find and improved it as much as I could last kernel 
cycle.

Put me and the users out of our misery and merge it now or delete it forever 
please. And if the meaningless handwaving that I 100% expect as a response 
begins again, then that's fine. I'll take that as a no and you can dump it.

-- 
-ck
