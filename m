Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYJZSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYJZSic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYJZSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:38:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39407 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYJZSiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:38:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 11:38:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kerneloops.org: 2.6.28-rc regression in epoll (list corruption)
In-Reply-To: <20081026112920.28e7dccc@infradead.org>
Message-ID: <Pine.LNX.4.64.0810261137130.19212@alien.or.mcafeemobile.com>
References: <20081026112920.28e7dccc@infradead.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Arjan van de Ven wrote:

> This one is upcoming fast (and I just hit it as well)
> 
> http://www.kerneloops.org/searchweek.php?search=ep_poll_callback
> 
> seems epoll grew some list corruption....

I sent a patch Andrew-ward on 10/17:

http://marc.info/?l=linux-kernel&m=122428548613067&w=2



- Davide


