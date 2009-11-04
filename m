Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZKDNkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZKDNkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZKDNkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:40:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbZKDNkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:40:41 -0500
Date: Wed, 4 Nov 2009 08:39:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC] Block IO Controller V1
Message-ID: <20091104133955.GA13780@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <20091104074333.GV8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104074333.GV8742@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 08:43:33AM +0100, Jens Axboe wrote:
> On Tue, Nov 03 2009, Vivek Goyal wrote:
> > Hi All,
> > 
> > This is V1 of the Block IO controller patches on top of 2.6.32-rc5.
> 
> Thanks for posting this Vivek. Can you rebase the patches on top of my
> for-2.6.33 branch, there are a bigger-than-usual number of pending CFQ
> patches in there so things won't apply directly.
> 
> If you do that, I'll pull these patches into testing branch and
> hopefully merge it in soonish. This patchset looks a lot more mergeable,
> thanks!
> 

Thanks Jens. Sure, will rebase the patches on top of "for-2.6.33" branch
and repost.

Thanks
Vivek
