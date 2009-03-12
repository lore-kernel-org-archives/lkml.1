Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZCLPAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZCLPAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZCLO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:59:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449AbZCLO7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:59:50 -0400
Date: Thu, 12 Mar 2009 10:57:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: anqin <anqin.qin@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, oz-kernel@redhat.com,
       paolo.valente@unimore.it, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       menage@google.com, jmoyer@redhat.com, fchecconi@gmail.com,
       arozansk@redhat.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       fernando@intellilink.co.jp, balbir@linux.vnet.ibm.com
Subject: Re: [RFC] IO Controller
Message-ID: <20090312145730.GG10919@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <49B8810B.7030603@oss.ntt.co.jp> <d95d44a20903112340s3c77807dt465e68901747ad89@mail.gmail.com> <49B8B1FB.1040506@cn.fujitsu.com> <d95d44a20903120011m4a7281enf17b31b9aaf7c937@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d95d44a20903120011m4a7281enf17b31b9aaf7c937@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 03:11:07PM +0800, anqin wrote:
> > Why? When this is ready to be merged, then it should be based on Jens' block-tree,
> > or akpm's mm tree. And this version currently is based on 2.6.29-rc4, so if you
> > want to try it out, just prepare a 2.6.29-rc4 kernel tree.
> >
> 
> I have checked the LKML and see these patches (on web pages) are based on
> 2.6.27. It seemed too old.
> 
> You mean that the codes have new patch files in 2.6.29-rc4?

I guess my mistake that I did not specify the kernel version in my mail.

These patches should apply on top of 2.6.29-rc7. 

Thanks
Vivek
