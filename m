Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYKRRcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYKRRcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYKRRcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:32:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46369 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbYKRRcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:32:41 -0500
Date: Tue, 18 Nov 2008 17:32:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Fredrik =?ISO-8859-14?B?TWFya3N0cvZt?=" 
	<fredrik.markstrom@avalonenterprise.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081118173240.6a48fc42@lxorguk.ukuu.org.uk>
In-Reply-To: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 17:16:44 +0100
"Fredrik Markström"  <fredrik.markstrom@avalonenterprise.com> wrote:

> Linus, others...
> 
> I'm working for as a consultant for a large hardware company porting
> Linux to their new cpu-architecture and everything is pretty much
> up and running. Now they want us to develop a closed-source (to
> protect their IP) ethernet driver for their proprietary Ethernet MAC.
> 
> My question is:    Is there a fair way to do this and still comply to
> the intent and spirit of the Linux licensing ?

Ask a lawyer not a kernel hacker. The license is quite clear that if its
a derivative work it must be GPL. Whether it is derivative is a matter
for lawyers to ascertain and you should consult a good one if you wish to
go dancing in minefields. In particular it is wise to remember that the
copyright holders including almost every other large cpu vendor and so
will include their competitors....

As to the spirit, the answer I think is: no.
