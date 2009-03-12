Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZCLKHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZCLKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZCLKHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:07:06 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37314 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753942AbZCLKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:07:04 -0400
Date: Thu, 12 Mar 2009 19:07:00 +0900 (JST)
Message-Id: <20090312.190700.260100263.ryov@valinux.co.jp>
To: akpm@linux-foundation.org
Cc: vgoyal@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com,
       fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, arozansk@redhat.com, jmoyer@redhat.com,
       oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090312001146.74591b9d.akpm@linux-foundation.org>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	<1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	<20090312001146.74591b9d.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> Also..  there are so many IO controller implementations that I've lost
> track of who is doing what.  I do have one private report here that
> Andreas's controller "is incredibly productive for us and has allowed
> us to put twice as many users per server with faster times for all
> users".  Which is pretty stunning, although it should be viewed as a
> condemnation of the current code, I'm afraid.

I'm developing dm-ioband, which is an another IO controller, and I
would like to hear your comments about dm-ioband if you have.

dm-ioband web page:
http://people.valinux.co.jp/~ryov/dm-ioband/

> So my question is: what is the definitive list of
> proposed-io-controller-implementations and how do I cunningly get all
> you guys to check each others homework? :)

Dm-ioband is implemented as a device-mapper driver, so I'm proposing
dm-ioband to dm-devel and I hope device-mapper staffs take care of it.

Thanks,
Ryo Tsuruta
