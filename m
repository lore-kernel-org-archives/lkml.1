Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZIIAtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZIIAtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZIIAtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:49:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56788 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZIIAtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:49:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akpm@linux-foundation.org
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
Message-Id: <20090909094529.0CD6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 09:49:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This release doesn't boot on my ia64 test box.
After following two patches reverted, booting was successful.

	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
	Kamezawa-san's kcore patch series


Mel, Kamezawa-san, Can you please gime me any advise?




