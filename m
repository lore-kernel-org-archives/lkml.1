Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYAHSZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYAHSZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYAHSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:24:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33548 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbYAHSY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:24:58 -0500
Date: Tue, 8 Jan 2008 18:22:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080108182244.1c88c85c@lxorguk.ukuu.org.uk>
In-Reply-To: <slrnfo7fgh.fne.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	<20080108164847.GA16462@skl-net.de>
	<slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
	<1a9da18c0801081007q1ed8ce04x7a78e880ee5bcac7@mail.gmail.com>
	<slrnfo7fgh.fne.tuomov@jolt.modeemi.cs.tut.fi>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 18:16:49 +0000 (UTC)
Tuomo Valkonen <tuomov@iki.fi> wrote:

> On 2008-01-08, Masoud Sharbiani "ÙØ³Ø¹ÙØ¯ Ø´Ø±Ø¨ÛØ§ÙÛ" <masouds@masoud.ir> wrote:
> > It isn't a bug. It is a feature; 
> 
> To me, it seems to be a rather clear bug when the last-checked field 
> contains an absurd value of years ago, on _all_ disks, and yet there's
> no complaint of other superblock corruption.

So report it to your distribution vendor, and they can help you work out
why you are about the only person on the planet reporting that problem.

Alan
