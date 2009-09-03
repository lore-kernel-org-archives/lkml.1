Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZICAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZICAYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZICAYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:24:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50073 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZICAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:24:40 -0400
Message-ID: <61624a1a836fe4f48d76af9b431eba39.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661de9470909021258j7fcc71fcv27d284738d1e37e3@mail.gmail.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
    <20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
    <20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
    <661de9470909021258j7fcc71fcv27d284738d1e37e3@mail.gmail.com>
Date: Thu, 3 Sep 2009 09:24:39 +0900 (JST)
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh さんは書きました：
> On Wed, Sep 2, 2009 at 2:59 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> I'm sorry that I'll be absent tomorrow. This is dump of current code.
>> IMHO, this version is enough simple.
>>
>> My next target is css's refcnt per page. I think we never need it...
>
> Is this against 27th August 2009 mmotm?
>
Onto mmotm-27+ all patches I sent. Maybe arguments to res_counter will
HUNK, at least

Thanks,
-Kame

> Balbir Singh
>


