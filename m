Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbXFNUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbXFNUsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXFNUse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:48:34 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3250 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXFNUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:48:33 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 13:47:41 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEGCEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200706141033.22605.bernd.paysan@gmx.de>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 13:48:05 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 14 Jun 2007 13:48:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What about if your GPL program ends up in a piece of hardware
> (e.g. a ROM,
> or an embedded ROM, or if it's some GPL code from OpenCores, as gate
> netlist in silicon)? My interpretation is that you need a permission from
> the author for doing that, unless there's an easy way to replace
> it with a
> modified copy (e.g. if you put the OpenCores stuff into an FPGA,
> replacing
> the configuration PROM would do it).

The GPL does not require it to be easy in fact to modify the piece of
software. It just requires that you have the right to modify it, that is,
that there be no legal obstacles in your way. You are entitled to the source
code in modifiable, understandable form. There are no legal restrictions,
other than those in the GPL and in the law, on what you can do with it.

What you are actually *able* to do, however, depends upon a wide variety of
factors way outside the scope of the GPL.

By the way, I have a lot of sympathy for the argument that *if* you provide
me a binary made from GPL'd code that required a key to produce that binary,
I am entitled to that key. The key is precisely analogous to any other piece
of source code -- it is mathematically 'combined' and 'processed' by tools
to produce the final, distributed executable. If there's some rational basis
for a legal difference between a signing key and a header file, I don't know
what it is.

DS


