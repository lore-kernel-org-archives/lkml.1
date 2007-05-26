Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXEZSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXEZSUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbXEZSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:20:26 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674AbXEZSUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:20:25 -0400
Date: Sat, 26 May 2007 11:19:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Message-Id: <20070526111934.e4650b6f.akpm@linux-foundation.org>
In-Reply-To: <200705262003.17403.mb@bu3sch.de>
References: <20070524195616.234280@gmx.net>
	<200705261918.09469.mb@bu3sch.de>
	<200705261924.33802.uwe.bugla@gmx.de>
	<200705262003.17403.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 20:03:17 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> Ok, please take git and get my development tree and try with that:
> 
> git clone http://bu3sch.de/git/wireless-dev.git
> 
> It's based on 2.6.22-rc1 and it works fine for me.

Uwe has a slow connection, and getting the whole git thing
set up would be quite a lump of effort.

I prepared a diff of the above tree against 2.6.21-rc3.  It is at
http://userweb.kernel.org/~akpm/git-mb.patch.gz
