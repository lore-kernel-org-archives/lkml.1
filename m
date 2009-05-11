Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZEKDAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZEKDAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZEKDA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:00:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZEKDA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:00:26 -0400
Message-ID: <4A079493.4030100@cn.fujitsu.com>
Date: Mon, 11 May 2009 10:59:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, nauman@google.com, dpshah@google.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: IO scheduler based IO Controller V2
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <4A014619.1040000@cn.fujitsu.com> <20090506161012.GC8180@redhat.com> <4A027348.6000808@cn.fujitsu.com> <20090508133740.GD7293@redhat.com>
In-Reply-To: <20090508133740.GD7293@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>>
> 
> Thanks Li and Gui for pointing out the problem. With you script, I could
> also produce lock validator warning as well as system freeze. I could
> identify at least two trouble spots. With following patch things seems
> to be fine on my system. Can you please give it a try.

  Hi Vivek,

  I'v tried this patch, and seems the problem is addressed. Thanks.

-- 
Regards
Gui Jianfeng

