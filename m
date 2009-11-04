Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZKDTUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZKDTUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbZKDTT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757889AbZKDTT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:19:57 -0500
Date: Wed, 4 Nov 2009 14:19:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC] Block IO Controller V1
Message-ID: <20091104191939.GL2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <x49ws26rtnw.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ws26rtnw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:12:19PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Hi All,
> >
> > This is V1 of the Block IO controller patches on top of 2.6.32-rc5.
> >
> > A consolidated patch can be found here:
> >
> > http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v1.patch
> 
> Overall it looks good.  Vivek, could you please run some benchmarks
> against a vanilla kernel and then with your patch applied and cgroups
> compiled in but not configured?
> 

Sure I can. Do you have something specific in mind?

Thanks
Vivek
