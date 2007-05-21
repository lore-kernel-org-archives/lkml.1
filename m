Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbXEUEUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbXEUEUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEUEUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:20:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3987 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXEUEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:20:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 20 May 2007 21:20:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read() call
In-Reply-To: <Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0705202117100.22011@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br> <20070520210210.9a895eec.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Davide Libenzi wrote:

> I think it fits the rule "buffer must be big enough for at least one sigingo".
                                                                       ^^^^^^^

/me wonders what sizeof(sigingo) is  :)


- Davide


