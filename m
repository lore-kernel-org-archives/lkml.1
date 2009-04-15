Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZDOD3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZDOD3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZDOD3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:29:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49768 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZDOD3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:29:03 -0400
Message-Id: <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: hugh@veritas.com
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, jmorris@namei.org,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Apr 2009 12:28:00 +0900
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk> <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15042009 #1849205, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hugh Dickins wrote:
> But my compiler on your config gives quite different function
> sizes: please would you post to the list or send me privately
> the output of "objdump -trd fs/exec.o", so we can check that.
I uploaded it to http://I-love.SAKURA.ne.jp/tmp/dump-2.6.30-rc1-fs-exec.txt

# gcc --version
gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.



Regards.
