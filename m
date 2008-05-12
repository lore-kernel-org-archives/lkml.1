Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYELDKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYELDKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYELDKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:10:21 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48406 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbYELDKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:10:20 -0400
Date: Mon, 12 May 2008 12:10:19 +0900 (JST)
Message-Id: <20080512.121019.183038803.ryov@valinux.co.jp>
To: s-uchida@ap.jp.nec.com
Cc: vtaras@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, axboe@kernel.dk,
       tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com, devel@openvz.org
Subject: Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth
 controlling subsystem for CGroups based on CFQ
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <004901c8b1bd$ec22fb70$c468f250$@jp.nec.com>
References: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
	<20080425.185444.115924172.ryov@valinux.co.jp>
	<004901c8b1bd$ec22fb70$c468f250$@jp.nec.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Uchida-san,
Thanks for your comments.

> In the test #2 and #3, did you use direct write?
> I guess you have used the non-direct write I/O (using cache).

Yes, I did. I used direct write in all tests.
I would appreciate it if you would try a test like I did.

--
Ryo Tsuruta <ryov@valinux.co.jp>
