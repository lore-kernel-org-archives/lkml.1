Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZAEJAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZAEJAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZAEJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:00:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39960 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZAEJAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:00:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
Message-Id: <20090105175433.D875.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  5 Jan 2009 18:00:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #
> page_fault-retry-with-nopage_retry.patch
> page_fault-retry-with-nopage_retry-fix.patch
> page_fault-retry-with-nopage_retry-fix-fix.patch

I oppose this.

Valdis.Kletnieks@vt.edu reported this patch has bug in
"28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms"
thread.

Nobody answer his question yet.



