Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZDXPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZDXPTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZDXPTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:19:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60109 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZDXPTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:19:36 -0400
Message-ID: <6e429f293fa1e3d02900a41039861119.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090424122441.GD3944@balbir.in.ibm.com>
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
    <20090424122441.GD3944@balbir.in.ibm.com>
Date: Sat, 25 Apr 2009 00:19:33 +0900 (JST)
Subject: Re: [RFC][PATCH 0/9] memcg soft limit v2 (new design)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-03
> 17:08:35]:
>> In this v2.
>>  - problems under use_hierarchy=1 case are fixed.
>>  - more hooks are added.
>>  - codes are cleaned up.
>>
>
> The results seem good so far with some basic tests I've been doing.
> I'll come back with more feedback, I would like to see this feature in
> -mm soon.
>
Thank you. I'll update this. But now I have bugfix patch for
stale swap caches (coop with Nishimura). Then, I'll go ahead one by one.

Regards,
-Kame

