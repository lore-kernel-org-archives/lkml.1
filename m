Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCYDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCYDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZCYDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:25:14 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58787 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZCYDZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:25:13 -0400
Message-Id: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp>
Subject: linux-next-20090324: undefined reference to `__this_fixmap_does_not_exist\'
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: wangchen@cn.fujitsu.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Mar 2009 12:24:58 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 24032009 #1774968, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I encountered below error.

arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
: undefined reference to `__this_fixmap_does_not_exist'
make: *** [.tmp_vmlinux1] Error 1

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-next-20090324

Regards.
