Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYDMWnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYDMWnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYDMWnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:43:43 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:57151 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYDMWnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:43:42 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: 9p: a couple of cleanup patches
Date: Mon, 14 Apr 2008 02:43:44 +0400
Message-Id: <1208126626-25838-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

An error spotted by sparse inspired me for a quick code review
of the 9p driver, which resulted in a couple of nitpicking
patches that follow.

The patches were build-tested both for a modularized driver
and when the latter was included into the kernel proper.

Please consider.

Thanks,
Dmitri Vorobiev
