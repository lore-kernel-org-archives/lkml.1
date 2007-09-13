Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXIMT56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXIMT56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbXIMT5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:57:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47316 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbXIMT5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:57:40 -0400
Date: Thu, 13 Sep 2007 12:56:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-rc6-git3 (not -git4): reiserfs bug
Message-Id: <20070913125632.885563da.randy.dunlap@oracle.com>
In-Reply-To: <20070913125448.e71a0b11.randy.dunlap@oracle.com>
References: <20070913125448.e71a0b11.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 12:54:48 -0700 Randy Dunlap wrote:

> on x86_64, 2 CPU + HT, 4 GB RAM:
> 
> reiserfs with blocksize of 1 KB, data=ordered
> 
> 
> [ 9828.242431] ------------[ cut here ]------------
> [ 9828.247056] kernel BUG at fs/reiserfs/journal.c:531!
> [ 9828.252017] invalid opcode: 0000 [1] SMP
> [ 9828.256070] CPU 0
> [ 9828.258105] Modules linked in: reiserfs loop
> [ 9828.262428] Pid: 16555, comm: pdflush Not tainted 2.6.23-rc6-git3 #1
                                                       ~~~~~~~~~~~~~~~~~~


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
