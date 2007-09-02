Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXIBOjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXIBOjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 10:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXIBOjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 10:39:44 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2722 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXIBOjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 10:39:43 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Sep 2007 07:39:35 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [RFC + PATCH] signalfd simplification
In-Reply-To: <20070902121943.GA141@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0709020737360.10114@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0709011618280.4045@alien.or.mcafeemobile.com>
 <20070902121943.GA141@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Oleg Nesterov wrote:

> We can optimize this later, using a "clever" wait_queue_func_t if needed.

Good idea. Will do ...


- Davide


