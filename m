Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbYGQSbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbYGQSbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYGQSbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:31:24 -0400
Received: from 82-39-188-205.cable.ubr03.benw.blueyonder.co.uk ([82.39.188.205]:38880
	"EHLO the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758759AbYGQSbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:31:23 -0400
Date: Wed, 16 Jul 2008 18:57:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Cheradenine Zakalwe" <sc.contact@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The state of linux security
Message-ID: <20080716185703.4c223ed8@the-village.bc.nu>
In-Reply-To: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
References: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the relative security of linux and the likely hood that smart people
> are able to cause a bit of mindless vandalism or get up to much worse.

Distributions assign CVE numbers to kernel vulnerabilities. As
distributions like Fedora ship current kernels they provide a pretty
complete summary.

> One more thing I'd like to throw out there on the issue of
> accountability is this:  How do I know that some developers have not
> been paid to specifically introduce some obscure security flaw? 

Wrong question. Thats a very naïve basis for thinking about security. Why
should end users care whether a flaw was added deliberately or by
mistake. What matters is that the flaw is identified. A passive attacker
observing a flaw and using it is at least as dangerous if not more so
than an active attacker.

Alan
