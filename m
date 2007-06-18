Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbXFRUEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbXFRUEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbXFRUEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:04:36 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4287 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761446AbXFRUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:04:35 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 13:03:40 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIECJELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070617080601.GA5440@brong.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 13:04:02 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 13:04:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, can I please rewrite my argument to:
>
> "The hardware manufacturer has built a custom BIOS and also written
> Linux kernel support for said BIOS.  They have released the kernel
> drivers under GPL as required, but have not released the code to the
> BIOS, instead just releasing the interface documentation.  The BIOS
> didn't exist before, and as they only intend to run Linux on the
> device, the BIOS design was heavily influenced around working well
> with Linux."
>
> Actually, we don't know that last bit, maybe they created the BIOS
> in a total vacuum and then wrote the Linux kernel driver later.
> Maybe not.
>
> Anyway, I think I've wound up arguing two sides of the same argument,
> oops.
>
> Bron.

Why does it matter whether the BIOS was "heavily influenced around working
well" with Linux? Your argument is arguing about things that have nothing to
do with anything. Your comparing things before you have any idea what the
right criteria for the comparison is.

Do you understand that all that matters is whether the BIOS contains
significant portions of the Linux code base? *Nothing* else matters.
Everything else will leave it an independent work and one that the authors
of Linux have nor right to claim any ownership of or control over.

I maintain a private application that has huge amounts of code that are
heavily influenced around working well with Linux. All the epoll code, for
example, in this code base meets that criteria. That doesn't mean it
*resembles* the Linux code in any way. It doesn't mean the Linux folks have
any right to tell me what I can and can't do with that code.

So you're arguing two sides of no argument at all.

DS


