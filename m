Return-Path: <linux-kernel-owner+w=401wt.eu-S1765304AbXGSMTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765304AbXGSMTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbXGSMTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:19:43 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42326 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbXGSMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:19:43 -0400
Date: Thu, 19 Jul 2007 15:19:40 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: AFS compile broken
Message-ID: <Pine.SOC.4.64.0707191516120.18397@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile todays git with modular AFS and gcc 4.1.3 prerelease 
in Debian unstable (gcc version 4.1.3 20070629 (prerelease) (Debian 
4.1.2-13)):

  CC [M]  fs/afs/flock.o
fs/afs/flock.c: In function 'afs_do_getlk':
fs/afs/flock.c:459: error: void value not ignored as it ought to be
make[3]: *** [fs/afs/flock.o] Error 1

-- 
Meelis Roos (mroos@linux.ee)
