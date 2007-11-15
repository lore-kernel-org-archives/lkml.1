Return-Path: <linux-kernel-owner+w=401wt.eu-S934255AbXKOXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255AbXKOXlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbXKOXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:41:08 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:44704 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762609AbXKOXlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:41:06 -0500
Message-ID: <473CD907.6030007@oracle.com>
Date: Thu, 15 Nov 2007 15:40:55 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] sys_indirect system call
References: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com> <473CC604.5050804@oracle.com> <alpine.LFD.0.9999.0711151431220.4260@woody.linux-foundation.org> <473CD6A3.2070306@redhat.com>
In-Reply-To: <473CD6A3.2070306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> BTW, I've botched the x86-on-x86_64 support.  I have a patch but need to
> patch it before I'll submit v3 of the patch set.  If you want to work on
> the patch and get syslet support going, let me know, I'll send the
> latest version.

I probably won't come around to trying sys_indirect with syslets until
next week, so it's probably fine for me to just wait for you to get v3
out.  (and I'm more likely to test native i386 or x86_64 anyway, so.. :))

- z
