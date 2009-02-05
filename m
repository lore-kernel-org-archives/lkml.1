Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZBEBDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZBEBDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZBEBDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:03:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51281 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZBEBDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:03:24 -0500
Message-ID: <498A3AB7.9060701@cn.fujitsu.com>
Date: Thu, 05 Feb 2009 09:02:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Subject: Re: [Bug #12611] kernel BUG at kernel/cgroup.c:398!
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.TrD.quYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.TrD.quYiJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12611
> Subject		: kernel BUG at kernel/cgroup.c:398!
> Submitter	: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Date		: 2009-01-28 15:49 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=123315721707796&w=4
> 

It has been fixed by the following commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=839ec5452ebfd5905b9c69b20ceb640903a8ea1a

