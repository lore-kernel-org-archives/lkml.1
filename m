Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYEZCqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYEZCqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 22:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYEZCq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 22:46:29 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:49991 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbYEZCq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 22:46:29 -0400
Date: Mon, 26 May 2008 11:46:27 +0900 (JST)
Message-Id: <20080526.114627.104044752.ryov@valinux.co.jp>
To: s-uchida@ap.jp.nec.com
Cc: axboe@kernel.dk, vtaras@openvz.org, containers@lists.linux-foundation.org,
       tom-sugawara@ap.jp.nec.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth
 controlling subsystem for CGroups based on CFQ
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <003701c8bc80$3a5f9ec0$af1edc40$@jp.nec.com>
References: <20080513.003316.226782406.ryov@valinux.co.jp>
	<20080522.220438.226802699.ryov@valinux.co.jp>
	<003701c8bc80$3a5f9ec0$af1edc40$@jp.nec.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uchida-san,

Thanks for your comment.

> Where did you build expanded CFQ schedulers?
> I guess that schedulers can be control I/Os if it is built on guest OS,
> But not if on Dom0.
> I guess you built on Dom0 so that you could not control I/O. (maybe, you say)

I built them on guest OS.

> I'm testing both systems and get similar results.
> I will report my test in next week.

I'm looking forward to your report.

Thanks,
Ryo Tsuruta
