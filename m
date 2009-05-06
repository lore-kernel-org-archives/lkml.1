Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbZEFWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbZEFWYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbZEFWWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:22:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762568AbZEFWWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:22:00 -0400
Message-ID: <4A020CD5.2000308@ds.jp.nec.com>
Date: Wed, 06 May 2009 18:19:01 -0400
From: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 18/18] io-controller: Debug hierarchical IO scheduling
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-19-git-send-email-vgoyal@redhat.com> <4A0203DB.1090809@ds.jp.nec.com> <20090506215833.GK8180@redhat.com>
In-Reply-To: <20090506215833.GK8180@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Vivek Goyal wrote:
> Hi Ikeda,
> 
> I think there is some issue with applying the patch. I think you have
> forgotten to apply following patch and that's why seeing all the issues.
> 
> "io-controller: Export disk time used and nr sectors dipatched through
> cgroups"
> 
> This patch changes elv_ioq_served() at the same time introduced additional
> field of total_sector_service etc.
> 
> Thanks
> Vivek

Oh!  you are right.  I missed it because it is out of the
thread...
Thanks and please forgive my pointless reply.
  

-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com

