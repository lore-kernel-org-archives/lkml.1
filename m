Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXDAGM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXDAGM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXDAGM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:12:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXDAGMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:12:55 -0400
Date: Sat, 31 Mar 2007 23:12:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 3/13] signal/timer/event fds v9 - signalfd wire up i386
 arch ...
Message-Id: <20070331231245.bb55c39d.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.16816.1175371770.3>
References: <send-serie.davidel@xmailserver.org.16816.1175371770.3>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 13:09:29 -0700 Davide Libenzi <davidel@xmailserver.org> wrote:

> This patch wire the signalfd system call to the i386 architecture.
> 

all your x86 syscall numbers got incremented due to lutiemsat().

The revoke sycalls got incremented by three.
