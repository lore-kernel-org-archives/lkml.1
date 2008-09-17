Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYIQOZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYIQOZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYIQOZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:25:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42053 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYIQOZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:25:20 -0400
Date: Wed, 17 Sep 2008 18:30:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>, Alan Cox <alan@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: sys_paccept: disable paccept() until API design is resolved
Message-ID: <20080917143042.GA376@tv-sign.ru>
References: <48CFA10D.2010106@gmail.com> <48D03E85.9030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D03E85.9030808@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16, Ulrich Drepper wrote:
>
> Michael Kerrisk wrote:
>
> > * The behavior of paccept() when interrupted by a signal is IMO
> >   strange:
>
> You use your own opinion as the deciding factor?

It would be very strange if Michael used the somebody else's opinion ;)

> The behavior differs
> from other uses but is consistent with the accept() behavior.

And Michael asks why this behaviour (and paccept() itself) is useful.
I must admit I don't understand this too.

It is very possible that we both just need the help from expert (you).
(Ulrich, there is no irony, seriously).

Oleg.

