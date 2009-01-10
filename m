Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbZAJAAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbZAJAAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZAJAA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:00:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:46043 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755661AbZAJAAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:00:25 -0500
Date: Sat, 10 Jan 2009 01:00:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Trivial Kernel Patches <trivial@kernel.org>
Subject: Re: [PATCH 0/5] [trivial] Fix dubious bitwise and/or usage.
In-Reply-To: <20090109234113.11800.55672.stgit@zaytsev.su>
Message-ID: <alpine.LNX.1.10.0901100059010.5377@jikos.suse.cz>
References: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Alexey Zaytsev wrote:

> Sorry to bother the lkml with such trivial stuff, but I could not get 
> any response from either Jiri Kosina ot trivial@ when I sent the patches 
> directly to them. Maybe a linux-trivial@ mailing list would be a good 
> idea..

Sorry, I have just been busy with too many other things during the merge 
window.

> ---
> 
> Alexey Zaytsev (5):
>       Fix dubious bitwise 'and' usage spotted by sparse.
>       Fix dubious bitwise 'and' usage spotted by sparse.
>       Fix dubious bitwise 'and' usage spotted by sparse.
>       Fix dubious bitwise 'or' usage spotted by sparse.
>       Fix dubious bitwise 'or' usage spotted by sparse.

I have applied all the patches with exception for the one patching 
drivers/media/video/gspca/m5602/m5602_s5k4aa.c, as it doesn't apply any 
more.

Thanks,

-- 
Jiri Kosina
SUSE Labs
