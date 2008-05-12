Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYELPd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYELPd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYELPdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:33:20 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36564 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751197AbYELPdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:33:19 -0400
Date: Tue, 13 May 2008 00:33:16 +0900 (JST)
Message-Id: <20080513.003316.226782406.ryov@valinux.co.jp>
To: s-uchida@ap.jp.nec.com
Cc: axboe@kernel.dk, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, vtaras@openvz.org,
       tom-sugawara@ap.jp.nec.com
Subject: Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O bandwidth
 controlling subsystem for CGroups based on CFQ
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080512.121019.183038803.ryov@valinux.co.jp>
References: <20080425.185444.115924172.ryov@valinux.co.jp>
	<004901c8b1bd$ec22fb70$c468f250$@jp.nec.com>
	<20080512.121019.183038803.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Uchida-san,

> > In the test #2 and #3, did you use direct write?
> > I guess you have used the non-direct write I/O (using cache).
> 
> Yes, I did. I used direct write in all tests.
> I would appreciate it if you would try a test like I did.

And I'll retest and report you back.

--
Ryo Tsuruta <ryov@valinux.co.jp>
