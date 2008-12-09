Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYLITme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYLITme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYLITmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:42:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52326 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYLITmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:42:24 -0500
Date: Tue, 9 Dec 2008 13:42:20 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Linux Torvalds <torvalds@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       MinChan Kim <minchan.kim@gmail.com>, arnd@arndb.de, jeremy@goop.org
Subject: Re: [RFC v11][PATCH 00/13] Kernel based checkpoint/restart
Message-ID: <20081209194220.GA20101@us.ibm.com>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Checkpoint-restart (c/r): fixed races in file handling (comments from
> from Al Viro). Updated and tested against v2.6.28-rc7 (feaf384...)
> 
> We'd like these to make it into -mm. This version addresses the
> last of the known bugs. Please pull at least the first 11 patches,
> as they are similar to before.

So far I'm finding no regressions and checkpoint/restart is working
perfectly for me.

Andrew, any chance of getting this round into -mm for some extra
testing?

thanks,
-serge
