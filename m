Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXCaVHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXCaVHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXCaVHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:07:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48363 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXCaVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:07:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Mar 2007 14:07:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 2/13] signal/timer/event fds v9 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703311325090.22390@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703311404090.22390@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703311325090.22390@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007, Davide Libenzi wrote:

> +config SIGNALFD
> +	bool "Eanble signalfd() system call" if EMBEDDED
              ^^^^^^
Alright ...



- Davide


