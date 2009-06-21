Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbZFUPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbZFUPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZFUPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 11:24:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34541 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZFUPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 11:24:19 -0400
Date: Sun, 21 Jun 2009 20:51:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [RFC] IO scheduler based io controller (V5)
Message-ID: <20090621152116.GC3728@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:

> 
> Hi All,
> 
> Here is the V5 of the IO controller patches generated on top of 2.6.30.
[snip]

> Testing
> =======
>

[snip]

I've not been reading through the discussions in complete detail, but
I see no reference to async reads or aio. In the case of aio, aio
presumes the context of the user space process. Could you elaborate on
any testing you've done with these cases? 

-- 
	Balbir
