Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbXHGSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbXHGSXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXHGSXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:23:41 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1040 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXHGSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:23:40 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RE: MODULE_LICENSE usage
Date: Tue, 7 Aug 2007 11:22:50 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEGLFPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070807161755.28e50234@the-village.bc.nu>
x-mimeole: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 07 Aug 2007 11:23:35 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 07 Aug 2007 11:23:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > My company has been given documentation and the library source under
> > the terms of an NDA with the chipset manufacturer.  We are permitted
> > to compile the library and distribute the resultant binary blob, but
> > not release the source to the library.
> >
> > The binary blob is linked into the driver we have written.  We don't
> > distribute this compiled module, customers are given the driver source
> > and the library blob, which they compile themselves.

> So you distribute a kernel derived work without following the GPL. I hope
> you've discussed that with your legal team in depth.

What "kernel derived work" would that be?

All he distributes is the binary blob and the source code to his driver. He
hasn't given sufficient information to establish that either of those is a
"kernel derived work". It's certainly possibly that they might be and
sensible to caution him that he's breaking the rules if they are, but you
can't establish that he's not following the GPL.

Of course, he would have a definitely problem if he, or anyone else,
distributed the resulting binary.

DS


