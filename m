Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYAIDE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYAIDE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYAIDEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:04:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbYAIDEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:04:20 -0500
Date: Wed, 9 Jan 2008 03:02:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops?
Message-ID: <20080109030215.4e3f0992@lxorguk.ukuu.org.uk>
In-Reply-To: <6d291e080801081825g951ef59j1eb37d6b43f11ec5@mail.gmail.com>
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
	<20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
	<6d291e080801081825g951ef59j1eb37d6b43f11ec5@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Except this time when rebooting the machine i got a kernel oops
> message and it didn't boot completely. I could not copy it but I did
> take a picture and now I have re-written the screen here(sorry about

That is interesting - that sort of error usually points at memory
corruption and early on tends to point at hardware (but not always). What
hard is in this system  and does it have over 4GB of RAM ?

