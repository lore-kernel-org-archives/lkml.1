Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYGQFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYGQFWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYGQFWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:22:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55938 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYGQFWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:22:44 -0400
Message-ID: <487ED5E3.1060900@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 13:17:23 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: {build fail} firmware: latest Linus tree modules_install fail
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make[1]: *** No rule to make target `/lib/firmware/$(dir', needed by `/lib/firmware/ttusb-budget/dspbootcode.bin'.  Stop.
make: *** [_modinst_post] Error 2

This error was outputed when I build the latest git tree of Linus's linux-2.6.

