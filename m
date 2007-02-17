Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXBQOTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXBQOTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 09:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030212AbXBQOTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 09:19:46 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1709 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202AbXBQOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 09:19:45 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Sat, 17 Feb 2007 06:19:07 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <er6mdq$ti8$1@sea.gmane.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 06:19:29 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 06:19:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Saturday 17 February 2007 03:42, David Schwartz wrote:
>
> > Again, see Lexmark v. Static Controls. If "make a toner cartridge that
> > works
> > with a particular Lexmark printer" is a functional idea, why is "make a
> > graphics driver that works with a particular Linux kernel" not? What is
> > the
> > difference you think matters?

> That you cannot build such modules without integrating parts of
> actual Linux
> kernel code (via #includes etc), whereas you can build compatible toner
> cartridges without using any original component.

Static Controls actually put a copy of Lexmark's 'Toner Loading Program' on
each compatible cartridge they made. The printer actually copies the TLP off
the cartridge. In other words, to make a compatible catridge, you do have to
use an original component. (Or at least, it's much more difficult not to.)

Static Controls argued that taking the TLP was the only practical way to
make a cartridge that would work with that printer. The court held that you
cannot use copyright to own every practical way to perform some function, so
as used in the compatible cartridge, the TLP was not protectable by
copyright. (The same work and the same elements can be protectable in one
context and not another.)

But in any event, your entire argument makes no sense. I was citing Lexmark
v. Static Controls here for the point that making an object to make X work
with Y is a function. I was responding to the argument that "Linux driver
for a particular piece of hardware" is more like a specific expression of an
idea than an idea. The court in this case held that a "toner cartridge that
works with a particular Lexmark printer" was an idea, not an expression.
It's hard to see how a "X1950 driver that works with a particular Linux
kernel" is similarly not an idea.

The implicit argument is that while you could not own every driver, you
might be able to own every Linux driver. That is, that while a "driver" is
an idea, a "Linux driver" might be a particular expression of an idea. But
if that were true, why couldn't Lexmark own every cartridge that worked with
this particular printer? (With a "toner cartridge" being an idea but a
"toner cartridge that works with this particular printer" being an
expression.)

DS


