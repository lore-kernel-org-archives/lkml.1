Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZCXD7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZCXD7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 23:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZCXD7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 23:59:23 -0400
Received: from mail.sunnorth.com.cn ([124.42.0.200]:15478 "EHLO
	bjmsw01.sunnorth.com.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408AbZCXD7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 23:59:23 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 23:59:22 EDT
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] score - New architecure port to SunplusCT S+CORE processor
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF4CC8EBC2.BDA9C1A9-ON48257583.0014767E-48257583.0014EE2B@sunnorth.com.cn>
From: liqin@sunnorth.com.cn
Date: Tue, 24 Mar 2009 11:46:48 +0800
X-MIMETrack: Serialize by Router on ntns1cn/Sunnorth(Release 7.0.2FP2|May 14, 2007) at
 03/24/2009 11:46:49 AM,
	Serialize complete at 03/24/2009 11:46:49 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus and folks,

We have ported Linux to the S+CORE processor, which is a 32-bit RISC 
embedded
microprocessor of Sunplus Core Technology.

SPG29X, SPG300(score core) processor have been used in game products.
and score toolchain have commit to gnu in 2006. We have a team to maintain
score code for linux kernel.

We would like to release a patch for kernel 2.6.29-rc8.
This patch include score header files, arch files and serial driver for 
spct6600(score core) platform.

For the other driver patches, I'll send them one by one in
small size latter. Thanks!

Would you merge them to the stock kernel? 

Patch information is slightly bigger, so I placed it on our SunplusCT web 
site.
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

Signed off by: Chen Liqin <liqin.chen@sunplusct.com, 
liqin@sunnorth.com.cn>

Thank you.
--
Liqin
