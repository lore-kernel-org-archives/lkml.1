Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYJTMtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYJTMtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYJTMs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:48:59 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36848 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830AbYJTMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:48:59 -0400
Date: Mon, 20 Oct 2008 21:48:58 +0900 (JST)
Message-Id: <20081020.214858.193685328.ryov@valinux.co.jp>
To: baramsori72@gmail.com
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       corsetproject@googlegroups.com
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
References: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
	<20081020.180129.193689104.ryov@valinux.co.jp>
	<2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong-Jae,

> Well, do you have any plan to upgrade bio-cgroup patches for stable
> latest kernel?
> but, I think it will be not easy job ^^

I think the memory cgroup will have a major change sometime soon.
So the new patch will be released after that.

Thanks,
Ryo Tsuruta
