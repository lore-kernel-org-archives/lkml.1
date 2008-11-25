Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYKYPv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYKYPv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKYPvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:51:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60788 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYKYPvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:51:50 -0500
Message-ID: <492C1EEC.2090500@redhat.com>
Date: Tue, 25 Nov 2008 10:51:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated statics.
References: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081125121842.26C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> memcg reclaim shouldn't change zone->recent_rotated statics.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Rik van Riel <riel@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All Rights Reversed
