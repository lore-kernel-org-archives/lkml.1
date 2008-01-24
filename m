Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYAXDUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYAXDUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 22:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYAXDU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 22:20:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50857 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYAXDU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 22:20:26 -0500
Date: Thu, 24 Jan 2008 12:19:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
In-Reply-To: <20080123102222.GA21455@csn.ul.ie>
References: <20080123105810.F295.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080123102222.GA21455@csn.ul.ie>
Message-Id: <20080124121310.175B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> To rule it out, can you also try with the patch below applied please? It
> should only make a difference on sparsemem so if discontigmem is still
> crashing, there is likely another problem. Assuming it crashes, 

Aaah, sorry.
I can't test again until next week.

I repost at that time...


> please
> post the full dmesg output with loglevel=8 on the command line. Thanks

You are right..
I omitted it at previous mail, sorry.

because piking up dmesg is very difficult when boot time crash. ;-)


- kosaki


