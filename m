Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628AbZGOCin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbZGOCin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZGOCim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:38:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZGOCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:38:42 -0400
Message-ID: <4A5D4128.6010607@kernel.org>
Date: Wed, 15 Jul 2009 11:38:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Small cleanup for z2ram.c
References: <4A5C56E9.2000409@cn.fujitsu.com>
In-Reply-To: <4A5C56E9.2000409@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Jul 2009 02:38:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei wrote:
> We should use Z2MINOR_COUNT as range argument in blk_unregister_region()
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Committed to #tj-block-for-linus (temp branch to collect block layer
patches while Jens is gone).

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus

Thanks.

-- 
tejun
