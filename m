Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXCJGaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXCJGaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXCJGaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:30:55 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44665 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbXCJGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:30:54 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 22:30:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/9] signalfd/timerfd v1 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703091531320.3761@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703092227370.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091531320.3761@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Davide Libenzi wrote:

> This patch series implements the new signalfd() and signalfd_dequeue()
------------------------------------------------------^^^^^^^^^^^^^^^^

Of course, wrong description. The signalfd_dequeue() call is gone, and 
signals are dequeued by read(2).


- Davide


