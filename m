Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbXCJHM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbXCJHM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbXCJHM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:12:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44684 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510AbXCJHMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:12:55 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 23:12:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 9/9] signalfd/timerfd v1 - timerfd compat code ...
In-Reply-To: <Pine.LNX.4.64.0703091538420.3761@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703092311040.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091538420.3761@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Davide Libenzi wrote:

> +asmlinkage long compat_sys_timerfd(int ufd, int tmrtype,
> +				   const struct timespec __user *utmr)
------------------------------------------------^^^^^^^^

compat_timespec, that is.


- Davide


