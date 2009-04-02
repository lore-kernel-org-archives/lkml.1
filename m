Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbZDBA5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbZDBA5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZDBA4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:56:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933105AbZDBA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:56:47 -0400
Message-ID: <49D40D67.9020909@cn.fujitsu.com>
Date: Thu, 02 Apr 2009 08:57:11 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Xiaodong <lixd@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Update Documentation: unix_dgram_qlen@proc.txt
References: <1238493359-22157-1-git-send-email-lixd@cn.fujitsu.com>
In-Reply-To: <1238493359-22157-1-git-send-email-lixd@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -There are  only  two  files  in this subdirectory. They control the delays for
> -deleting and destroying socket descriptors.
> +There is only one file in this directory.
> +unix_dgram_qlen limits the max number of datagrams queued in Unix domain
> +socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
>  

s/spicified/specified

>  2.8 /proc/sys/net/ipv4 - IPV4 settings
>  --------------------------------------

