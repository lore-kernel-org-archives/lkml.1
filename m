Return-Path: <linux-kernel-owner+w=401wt.eu-S1765941AbXLNWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765941AbXLNWbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXLNWbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:31:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42724 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754080AbXLNWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:31:15 -0500
Date: Fri, 14 Dec 2007 22:24:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange ATA problems
Message-ID: <20071214222458.59ab3de6@the-village.bc.nu>
In-Reply-To: <1197647095.3454.3.camel@fermat.scientia.net>
References: <1197591699.3453.38.camel@fermat.scientia.net>
	<47629E40.5020007@gmail.com>
	<1197647095.3454.3.camel@fermat.scientia.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 16:44:55 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> Hi Tejun.
> 
> 
> On Sat, 2007-12-15 at 00:16 +0900, Tejun Heo wrote:
> > Do you have log with timestamp?  It's difficult to tell what's going on
> > without knowing what happened when.
> Ah sorry,... I've completely missed that... perhaps those two problems
> were not related (at least there's so much time between).
> 
> Dec 13 17:05:51 fermat kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel

Can you reproduce this without the Nvidia stuff ?
