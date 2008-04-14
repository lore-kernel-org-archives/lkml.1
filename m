Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYDNBq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYDNBq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYDNBqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:46:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51284 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbYDNBqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:46:18 -0400
Message-ID: <4802B74D.5040906@jp.fujitsu.com>
Date: Mon, 14 Apr 2008 10:45:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Customize sched domain via cpuset (v2)
References: <47F21BE3.5030705@jp.fujitsu.com>	 <47F5F0BB.1080804@jp.fujitsu.com> <1207839195.7074.4.camel@twins>
In-Reply-To: <1207839195.7074.4.camel@twins>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> This seems like a sufficiently flexible interface. Paul, have you got
> any outstanding objections?
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Paul, could you give me your response?
I think it is better to push these patches into Ingo's scheduler tree
if you can also "acked-by" to them.

Thanks,
H.Seto
