Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYENRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYENRqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYENRqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:46:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40752 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753641AbYENRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:46:42 -0400
Date: Wed, 14 May 2008 18:35:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Harald Dunkel" <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080514183558.40178fe5@core>
In-Reply-To: <19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com>
References: <4829326A.6060808@t-online.de>
	<19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
	<4829D345.7020909@t-online.de>
	<19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
	<482B1BD2.8040400@t-online.de>
	<19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I run "su someuser" as root, then it gets stuck. No prompt. I cannot
> interrupt it with ^C or ^Z either. /var/log/auth.log says:

Is it then killable remotely, can you gdb it ?


