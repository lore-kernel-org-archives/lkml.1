Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYGVKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYGVKCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYGVKCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:02:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55987 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbYGVKCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:02:06 -0400
Date: Tue, 22 Jul 2008 10:44:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] Char: merge ip2main and ip2base
Message-ID: <20080722104441.3dc7caa1@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722024458.f609bb12.akpm@linux-foundation.org>
References: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
	<20080722024458.f609bb12.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I applied these four, but there's a fly in our ointment.
> 
> On 14 July, Akinobu Mita <akinobu.mita@gmail.com> sent a patch titled
> "ip2: avoid add_timer() with pending timer" which Alan acked and then
> claimed was "Queued for ttydev tree".  But afaict he then lost it.

Its queued but I can unqueue it as it isn't in the pile pending for Linus
yet.

