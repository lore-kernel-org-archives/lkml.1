Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYHSD2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYHSD2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYHSD2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:28:13 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:56776 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbYHSD2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:28:12 -0400
Date: Tue, 19 Aug 2008 12:28:11 +0900 (JST)
Message-Id: <20080819.122811.59660409.ryov@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, fernando@oss.ntt.co.jp
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080812.213449.104039151.ryov@valinux.co.jp>
	<20080812.213533.189720227.ryov@valinux.co.jp>
	<20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa-san,

> I'm now writing remove-lock-page-cgroup patches. it works well.
> please wait for a while...

I'm looking forward to those patches.

By the way, I'm glad if memory-cgroup has a feature which can make a
page_cgroup move between cgroups with small overhead. It makes
bio-cgroup improve the accuracy of tracking down pages.

Thanks,
Ryo Tsuruta
