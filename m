Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbYJTJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbYJTJBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJTJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:01:32 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53930 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbYJTJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:01:32 -0400
Date: Mon, 20 Oct 2008 18:01:30 +0900 (JST)
Message-Id: <20081020.180129.193689104.ryov@valinux.co.jp>
To: baramsori72@gmail.com
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       corsetproject@googlegroups.com
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong-Jae,

> I am trying to install your new released dm-ioband v1.8.0
> I/O bandwidth controller v1.8.0 could be adjusted to  the latest
> stable kernel 2.6.27.1
> it was good news for me
> but, I had a problem when I try to patch bio-cgroup files to  stable
> kernel 2.6.27.1
> many patch failure and hunk messages were occured.
> 
> Can you check bio-cgroup patch files against stable kernel 2.6.27.1?

bio-cgroup patch can apply only to 2.6.27-rc5-mm1 so far.
Please use 2.6.27-rc5-mm1 to try both bio-cgroup and dm-ioband,
dm-ioband v1.8.0 can also apply to 2.6.27-rc5-mm1.

Thanks,
Ryo Tsuruta
