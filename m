Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYKRT3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYKRT3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYKRT3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:29:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41674 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319AbYKRT3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:29:33 -0500
Date: Tue, 18 Nov 2008 19:29:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Fredrik =?ISO-8859-14?B?TWFya3N0cvZt?= 
	<fredrik.markstrom@avalonenterprise.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081118192942.3c676f0d@lxorguk.ukuu.org.uk>
In-Reply-To: <63125.1227036333@turing-police.cc.vt.edu>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
	<63125.1227036333@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> an entire CPU architecture and be OK on the GPL licensing of all the code
> in arch/new-foo-cpu that exposes the IP of the cpu design, but they're worried
> about the special sauce in a freakin' *ethernet controller*?

Not entirely. There are several reasons this may occur
- They could have something genuinely new - unlikely to be honest
- They could think they have something genuinely new but don't
- They may not yet have filed some relevant patent applications in which
case they have to worry about secrecy

and other reasons.

Probably they should talk to the Linux Foundation. I'm not sure that
assuming they are clueless is the first step. Understanding the problem
as they see it is more important and probably something the Linux
Foundation can help with and under a business to business framework.
