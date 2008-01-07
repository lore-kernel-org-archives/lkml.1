Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYAGXcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYAGXcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYAGXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:32:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756269AbYAGXcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:32:06 -0500
Date: Mon, 7 Jan 2008 23:30:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops?
Message-ID: <20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
In-Reply-To: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
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

On Mon, 7 Jan 2008 17:15:01 -0600
"Stoyan Gaydarov" <stoyboyker@gmail.com> wrote:

> Today I upgraded my kernel from 2.6.23.9 to 2.6.23.12 and in the past
> 30 minutes I have had to restart my computer twice.
> I believe its a kernel oops or a kernel panic because when the
> computer freezes it blinks the caps and scroll lock LEDs.
> I don't know what is causing the problem but I am willing to help, I
> can provide you with any information you need.
> The only problem is that I don't know how to debug the system myself.
> If anyone can tell me what to do to I can do it and give back the
> information.

When the machine hangs in graphical mode its quite hard to get the data
out - one of the long term todo items is to fix that.

Boot the machine and leave it in text mode (or if it boots to graphical
mode then switch to a text console/text mode) and wait.. with "luck" it
will show the same problem in text mode and give you a meaningful screen
dump you can then write down (or grab with a digital camera)

Alan
