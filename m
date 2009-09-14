Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZINCNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZINCNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZINCNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:13:10 -0400
Received: from 124-219-29-226.vdslpro.static.apol.com.tw ([124.219.29.226]:53074
	"EHLO mswedge1.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbZINCNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:13:09 -0400
X-Greylist: delayed 1110 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Sep 2009 22:13:09 EDT
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org,
       liqin.gnu@gmail.com
Subject: [GIT PULL, v4] S+core architecture (arch/score) support
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF86273AF3.3B227B93-ON48257631.0006A5D3-48257631.0008C45B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 14 Sep 2009 09:27:57 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/09/14 ?? 09:27:58,
	Serialize complete at 2009/09/14 ?? 09:27:58
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We had setup a git server at gitserver.sunplusct.com,
This repository contains Linux support for S+core CPU.
it's base on Linux 2.6.31-rc7 and Arnd asm-generic repository.

please pull:
        git pull git://gitserver.sunplusct.com/linux-2.6-score.git 
for-linus

Changes in v4:
Sending pull request again.

Changes in v3:
With the help of Arnd and Roland.

Changes in v2:
Christoph Hellwig and Arnd review it.

Thanks,
Liqin

-----
