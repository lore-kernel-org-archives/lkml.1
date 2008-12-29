Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYL2Axg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYL2Axg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYL2Ax1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:53:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55039 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbYL2Ax0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:53:26 -0500
Date: Mon, 29 Dec 2008 00:53:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: Should <linux/serial.h> define __u32?
Message-ID: <20081229005334.656818bb@lxorguk.ukuu.org.uk>
In-Reply-To: <4957FCA4.4010201@gmail.com>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
	<20081010103637.31597.41557.stgit@localhost.localdomain>
	<4957FCA4.4010201@gmail.com>
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

On Sun, 28 Dec 2008 14:24:36 -0800
walt <w41ter@gmail.com> wrote:

> Hi Alan and Linus,
> 
> A little background to explain the reason for my question:
> 
> My linux distribution just updated /usr/include/linux to 2.6.28,
> which broke the compilation of wine.

I believe there is a patch queued for that one. It's certainly already
got a bug filed and I'm pretty sure its in the patch queue. I'll take a
look when I'm back at work.
