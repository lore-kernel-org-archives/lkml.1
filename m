Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYHUKOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYHUKOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYHUKOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:14:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51172 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYHUKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:14:24 -0400
Date: Thu, 21 Aug 2008 19:13:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: kosaki.motohiro@jp.fujitsu.com, peterz@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com, travis@sgi.com
In-Reply-To: <20080821.030932.75221247.davem@davemloft.net>
References: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080821.030932.75221247.davem@davemloft.net>
Message-Id: <20080821191330.22B2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 21 Aug 2008 19:04:28 +0900
> 
> > but I worry about it works on sparc64...
> 
> It should.

Could you please confirm it?



