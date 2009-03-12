Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZCLByK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZCLByK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZCLBxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:53:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62493 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZCLBxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:53:55 -0400
Message-ID: <49B86B3A.2050506@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 09:54:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 6/5] softlimit document
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com> <20090312100112.6f010cae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312100112.6f010cae.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +    - memory.softlimit_priority.
> +	- priority of this cgroup at softlimit reclaim.
> +	  Allowed priority level is 3-0 and 3 is the lowest.
> +	  If 0, this cgroup will not be target of softlimit.
> +

Seems this document is the older one...


