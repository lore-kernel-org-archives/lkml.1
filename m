Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZDMEGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZDMEGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZDMEFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:05:53 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39865 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751098AbZDMEFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:05:53 -0400
Date: Mon, 13 Apr 2009 13:05:52 +0900 (JST)
Message-Id: <20090413.130552.226792299.ryov@valinux.co.jp>
To: agk@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: dm-ioband: Test results.
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair and all,

I did more tests on dm-ioband and I've posted the test items and
results on my website. The results are very good.
http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls

I hope someone will test dm-ioband and report back to the dm-devel
mailing list.

Alasdair, could you please merge dm-ioband into upstream? Or could
you please tell me why dm-ioband can't be merged?

Thanks,
Ryo Tsuruta

To know the details of dm-ioband:
http://people.valinux.co.jp/~ryov/dm-ioband/

RPM packages for RHEL5 and CentOS5 are available:
http://people.valinux.co.jp/~ryov/dm-ioband/binary.html
