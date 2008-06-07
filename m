Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbYFGEuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbYFGEuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 00:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYFGEuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 00:50:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56226 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYFGEuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 00:50:09 -0400
Date: Sat, 07 Jun 2008 13:46:00 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Subject: Re: [PATCH 3/3 v2] per-task-delay-accounting: update document and getdelays.c for memory reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, nagar@watson.ibm.com,
       balbir@in.ibm.com, sekharan@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080605163338.8880eb7f.kobayashi.kk@ncos.nec.co.jp>
References: <20080605162759.a6adf291.kobayashi.kk@ncos.nec.co.jp> <20080605163338.8880eb7f.kobayashi.kk@ncos.nec.co.jp>
Message-Id: <20080607134438.9C43.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update document and make getdelays.c show delay accounting for memory reclaim.
> 
> For making a distinction between "swapping in pages" and "memory reclaim"
> in getdelays.c, MEM is changed to SWAP.
> 
> Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>

looks good to me.

but I don't know s/MEM/SWAP/ renaming is good or bad.
You should hear delayacct developer opinion. IMHO.





