Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZC0FQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZC0FQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZC0FQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:16:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41207 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZC0FQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:16:16 -0400
Date: Fri, 27 Mar 2009 14:14:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 5/8] memcg soft limit (yet another new design) v1
Message-Id: <20090327141446.ca77a921.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090327140923.7dbbf677.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090327140923.7dbbf677.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 14:09:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> memcg's reclaim routine is designed to ignore locality andplacements and
> then, inactive_anon_is_low() function doesn't take "zone" as its argument.
> 
The subject should be "modify inactive_anon_is_low"...

-Kame

