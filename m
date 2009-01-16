Return-Path: <linux-kernel-owner+w=401wt.eu-S935323AbZAPBTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323AbZAPBTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZAPBTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:19:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZAPBTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:19:21 -0500
Message-ID: <496FE06C.4070900@cn.fujitsu.com>
Date: Fri, 16 Jan 2009 09:18:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] cgroup: add CSS ID
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com> <20090115192522.0130e550.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115192522.0130e550.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Patch for Per-CSS(Cgroup Subsys State) ID and private hierarchy code.
> 
> This patch attaches unique ID to each css and provides following.
> 

...

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>


