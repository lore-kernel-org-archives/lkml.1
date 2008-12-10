Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYLJBEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYLJBEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYLJBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:03:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLJBD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:03:59 -0500
Message-ID: <493F151B.50800@cn.fujitsu.com>
Date: Wed, 10 Dec 2008 09:02:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/6] memcg: Documentation for internal implementation
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>	<20081209200413.d842ede4.kamezawa.hiroyu@jp.fujitsu.com> <20081210092735.25d9d618.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081210092735.25d9d618.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Paul, Balbir
> 
> I have a question.
> 
> Why cgroup's documentation directroy is divided into 2 places ?
> 
> 	Documentation/cgroups
> 	             /controllers
> 

Documentation/cgroups was created by Matt Helsley, when he added freezer-subsystem.txt,
and he also moved cgroups.txt to the new Documentation/cgroups.

> If no strong demands, I'd like to remove "controllers" directroy and move

I prepared a patch to do so long ago, but didn't ever send it out.

> contents under "cgroups". Some people complains me that finding document
> for memcg is not easy.
> 
