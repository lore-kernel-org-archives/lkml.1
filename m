Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbYLDFEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbYLDFEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYLDFEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:04:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35847 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYLDFEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:04:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: improve reclaim throuput to bail out patch take2
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie
In-Reply-To: <28c262360812032020k6259b71bx5609626db622a884@mail.gmail.com>
References: <20081204102729.1D5C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360812032020k6259b71bx5609626db622a884@mail.gmail.com>
Message-Id: <20081204132253.1D68.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 14:04:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi, Kosaki-san.
> 
> It's a great improvement with only one variable than I expected. :)
> What is your test environment ? (CPU, L1, L2 cache size and so )
> Just out of curiosity.

CPU: ia64x8
L1: 16KB
L2: 512KB
L3: 24MB




