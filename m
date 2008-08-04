Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYHDAu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYHDAu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYHDAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:50:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYHDAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:50:14 -0400
Message-ID: <489651E6.90001@cn.fujitsu.com>
Date: Mon, 04 Aug 2008 08:48:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, Carl Henrik Lunde <chlunde@ping.uio.no>,
       axboe@kernel.dk, matt@bluehost.com, roberto@unbit.it,
       Marco Innocenti <m.innocenti@cineca.it>, randy.dunlap@oracle.com,
       Divyesh Shah <dpshah@google.com>, subrata@linux.vnet.ibm.com,
       eric.rannaud@gmail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] i/o controller infrastructure
References: <> <1217801698-13438-3-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1217801698-13438-3-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> This is the core io-throttle kernel infrastructure. It creates the basic
> interfaces to cgroups and implements the I/O measurement and throttling
> functions.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  block/Makefile                |    2 ++
>  include/linux/cgroup_subsys.h |    6 ++++++
>  init/Kconfig                  |   10 ++++++++++
>  3 files changed, 18 insertions(+), 0 deletions(-)
> 

where is block/blk-io-throttle.c and include/linux/blk-io-throttle.h?

