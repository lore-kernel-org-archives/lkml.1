Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYAUAjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYAUAjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYAUAjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:39:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47309 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbYAUAji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:39:38 -0500
Date: Mon, 21 Jan 2008 09:38:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
In-Reply-To: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie>
Message-Id: <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> A fix[1] was merged to the x86.git tree that allowed NUMA kernels to boot
> on normal x86 machines (and not just NUMA-Q, Summit etc.). I took a look
> at the restrictions on setting NUMA on x86 to see if they could be lifted.

Interesting!

I will test tomorrow.
I think this patch become easy to the porting of fakenuma.


