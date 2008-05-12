Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYELVVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYELVVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYELVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:21:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54359 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752510AbYELVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:21:31 -0400
Date: Mon, 12 May 2008 22:11:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: Tracking and crediting bug reporters
Message-ID: <20080512221109.4fa51a71@core>
In-Reply-To: <4828AE8D.4000209@gmail.com>
References: <4388.1210613272@vena.lwn.net>
	<20080512192019.6684f719@core>
	<4828AE8D.4000209@gmail.com>
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

> > I cannot add a tag with a third party personal information upon it
> > without their permission nor can anyone else in a part of the world with
> > any vaguely resembling privacy laws.
> 
> IANAL. Unless it's a public information, no? (As reports are.)

If they made it public fine - although building a database of that
requires care. That was my point. You need specific permission of the bug
reporter. Given bug reporters may have personal reasons (including 'works
at Microsoft') and business ones (from 'company policy' to 'three letter
agency') for not wanting the information public.

> Otherwise we would be in a big trouble, since we do this as far as can git 
> history tell at least.

No: The Signed-off-by in GIT references the 1.1 contributor agreement
which specifically deals with that case.

