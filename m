Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYARJTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYARJTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYARJTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:19:40 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57430 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYARJTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:19:38 -0500
Message-Id: <200801180919.m0I9JEOV060912@www262.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 18:19:14 +0900
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org> <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp> <20080117204247.5318e500.akpm@linux-foundation.org> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I tried gcc 4.1.2 on Fedora 8 using
http://I-love.SAKURA.ne.jp/tmp/config-2.6.24-rc8-mm1 .
Same result as gcc 3.3.5 on Debian/Sarge.

It seems kernel config (and possibly hardware) dependent
rather than gcc version dependent.

This is VMware workstation 6.0.0 on Thinkpad X60 (Core 2 Duo).

Regards.
