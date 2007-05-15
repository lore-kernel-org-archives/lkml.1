Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbXEOMxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbXEOMxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXEOMxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:53:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:28936 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXEOMxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:53:47 -0400
Message-ID: <4649AD40.7010102@openvz.org>
Date: Tue, 15 May 2007 16:53:20 +0400
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [Devel] [patch i2o]  i2o layer cleanup
References: <4649AA6C.2080808@sw.ru>
In-Reply-To: <4649AA6C.2080808@sw.ru>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Kirill Korotaev <dev@openvz.org>


Vasily Averin wrote:
> Andrew,
> 
> I've fixed a number of issues in i2o layer:
> [patch i2o 1/6] i2o_cfg_passthru cleanup (memory leak and infinite loop)
> [patch i2o 2/6] wrong memory access in i2o_block_device_lock()
> [patch i2o 3/6] i2o message leak in i2o_msg_post_wait_mem()
> [patch i2o 4/6] i2o proc reading oops
> [patch i2o 5/6] i2o_proc files permission
> [patch i2o 6/6] i2o debug output cleanup
> 
> However because of Markus Lidel is not i2o maintainer now, I do not understand
> who should agree the following patches.
> 
> Thank you,
> 	Vasily Averin
> 
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
> 

