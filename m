Return-Path: <linux-kernel-owner+w=401wt.eu-S932266Ab0A1AQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0A1AQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953Ab0A1AQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:16:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56356 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0A1AQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:16:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Jan 2010 09:12:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/2] oom-kill: add lowmem usage aware oom kill
 handling
Message-Id: <20100128091246.33a3cf11.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 15:30:53 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> I updated oom-kill-add-lowmem-usage-aware-oom-kill-handling.patch.
> 
> I added "clean up" patch before new feature. I divided it into 2 patches.
> 
> [1/2] clean up vm related sysctl variable declaration
> [2/2] lowmem aware oom-kill.
> 
> I rewrote patch description for 2/2 much. Plz point out if not enough yet.
> And 2/2 includes some bug fixes.
> 
> Thank you for all helps.
> 
I stop all this work. 

Sorry for noise. Already I asked Andrew to drop lowmem_rss counting.

Thanks,
-Kame

