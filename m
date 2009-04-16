Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZDPFgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZDPFgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDPFf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:35:59 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65033 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZDPFf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:35:58 -0400
Message-Id: <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: hugh@veritas.com
Cc: arjan@linux.intel.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Apr 2009 14:35:11 +0900
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk> <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils> <200904150328.n3F3S0F9083222@www262.sakura.ne.jp> <Pine.LNX.4.64.0904152036150.27354@blonde.anvils> <200904160046.n3G0ki9o028612@www262.sakura.ne.jp> <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 16042009 #1853576, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hugh Dickins wrote:
> I'd hoped to get confirmation that the mmap.c part of the patch
> was all the extra needed; but never mind, that's clearly good.
Yes. The mmap.c part solved khelper's current->mm == NULL warning.

> Thanks a lot: I'll send in a revert request,
> and the acct_stack_growth patch, later today.
Yes, please.

Thank you.
