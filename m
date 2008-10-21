Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYJUCBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYJUCBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 22:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYJUCBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 22:01:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51835 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYJUCBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 22:01:16 -0400
Date: Tue, 21 Oct 2008 11:00:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: baramsori72@gmail.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       corsetproject@googlegroups.com, fernando@oss.ntt.co.jp, agk@redhat.com
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
Message-Id: <20081021110048.949704bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081020.214858.193685328.ryov@valinux.co.jp>
References: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
	<20081020.180129.193689104.ryov@valinux.co.jp>
	<2891419e0810200313j5cac8541qff80614e3d784b1b@mail.gmail.com>
	<20081020.214858.193685328.ryov@valinux.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 21:48:58 +0900 (JST)
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi Dong-Jae,
> 
> > Well, do you have any plan to upgrade bio-cgroup patches for stable
> > latest kernel?
> > but, I think it will be not easy job ^^
> 
> I think the memory cgroup will have a major change sometime soon.
> So the new patch will be released after that.
> 

the newest mmotm has the newest *big* change. enjoy it ;)
I think no major change around page_cgroup will not occur for a while
but I myself have plan/patches to modify memcg itself's charge/uncharge
callpath.

Thanks,
-Kame

