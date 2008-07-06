Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYGFQpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYGFQpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYGFQph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:45:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYGFQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:45:36 -0400
Date: Sun, 6 Jul 2008 12:44:55 -0400
From: Alan Cox <alan@redhat.com>
To: Tim Connors <tim.w.connors@gmail.com>
Cc: Joe Peterson <joe@skyrush.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: tty session leader issue (was Re: 2.6.25.3: su gets stuck for root)
Message-ID: <20080706164455.GB18240@devserv.devel.redhat.com>
References: <484FDB63.6050504@skyrush.com> <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com> <485323C5.4030002@skyrush.com> <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com> <48540343.4010200@skyrush.com> <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com> <48542F75.5070605@skyrush.com> <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com> <486BC30C.6010705@skyrush.com> <alpine.DEB.1.10.0807062353450.30385@scuzzie.rather.puzzling.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807062353450.30385@scuzzie.rather.puzzling.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 12:08:58AM +1000, Tim Connors wrote:
> In summary, something in tty is certainly screwed.  Does anyone see a
> connection between all of these?

That they don't happen for me - at all is the only one I can suggest ? Most
of your comments are also not ones I've seen reported before.

Unfortunately 'works for me' doesn't tell me whether that is luck, distribution
specific, user configuration choices, gcc version, bugs in code , or whatever
and someone who sees the ^C problem is going to have to track it down.

Alan

