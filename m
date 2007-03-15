Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXCOQh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXCOQh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXCOQh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:37:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXCOQhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:37:55 -0400
Message-ID: <45F9757F.2020900@redhat.com>
Date: Thu, 15 Mar 2007 12:34:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-stable <stable@kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Three critical patches still aren't merged in 2.6.21
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been holding off sending these in for -stable until they're
merged, but now I wonder when that will happen.

http://lkml.org/lkml/2007/3/14/99
[PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix,de> 

http://lkml.org/lkml/2007/3/12/268
NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
From: Trond Myklebust <Trond.Myklebust@netapp.com>

http://lkml.org/lkml/2007/3/12/60
[patch] futex: PI state locking fix
From: Ingo Molnar <mingo@elte.hu>
