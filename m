Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZDUMLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZDUMLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZDUMKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:10:53 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60588 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbZDUMKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:10:52 -0400
Date: Tue, 21 Apr 2009 21:10:51 +0900 (JST)
Message-Id: <20090421.211051.183023683.ryov@valinux.co.jp>
To: nauman@google.com
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       dm-devel@redhat.com, agk@redhat.com, jens.axboe@oracle.com,
       vgoyal@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090421.210614.112619728.ryov@valinux.co.jp>
References: <20090420.172959.193682665.ryov@valinux.co.jp>
	<e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
	<20090421.210614.112619728.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nauman,

> > The real question is, once you create a version of dm-ioband that
> > co-operates with CFQ scheduler, how that solution would compare with
> > the patch set Vivek has posted? In my opinion, we need to converge to
> > one solution as soon as possible, so that we can work on it together
> > to refine and test it.
> 
> I think I can do some help for your work. but I want to continue the
> development of dm-ioband, because dm-ioband actually works well and
> I think it has some advantages against other IO controllers.
>   - It can use without cgroup.
>   - It can control bandwidth on a per partition basis.
>   - The driver module can be replaced without stopping the system.

In addition, dm-ioband can run on the RHEL5.

Thanks,
Ryo Tsuruta
