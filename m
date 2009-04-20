Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZDTIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZDTIkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZDTIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:39:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZDTIjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:39:54 -0400
Message-ID: <49EC34C1.6010709@cn.fujitsu.com>
Date: Mon, 20 Apr 2009 16:39:29 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1240090636-898-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
...
> 
> Implementation
> ~~~~~~~~~~~~~~
> Patchset against latest Linus' git:
> 
>   [PATCH 0/7] cgroup: block device IO controller (v14)
>   [PATCH 1/7] io-throttle documentation
>   [PATCH 2/7] res_counter: introduce ratelimiting attributes
>   [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
>   [PATCH 4/7] io-throttle controller infrastructure
>   [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
>   [PATCH 6/7] io-throttle instrumentation
>   [PATCH 7/7] export per-task io-throttle statistics to userspace

  Hi Andrea,

  I'd like to have a try this patchset, would you tell what's the kernel version
  and bio-cgroup version based on?

-- 
Regards
Gui Jianfeng

