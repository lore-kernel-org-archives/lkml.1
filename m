Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXBQVVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXBQVVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXBQVVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:21:12 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1468 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbXBQVVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:21:10 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <sepreece@gmail.com>, "Alexandre Oliva" <aoliva@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Sat, 17 Feb 2007 13:21:12 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEMEBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <7b69d1470702171129x36c4352cyc5b3a4b217729bf5@mail.gmail.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 13:21:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 17 Feb 2007 13:21:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On 2/17/07, Alexandre Oliva <aoliva@redhat.com> wrote:

> > Per this principle, it would seem that only source code and
> > hand-crafted object code would be governed by copyright, since
> > compilation is also an automated process.

> Well, compilation is probably equivalent to "translation", which is
> specifically included in the Act as forming a derivative work.

I would hope that courts will hold that "translation" still means what it
originally meant -- the creative process of converting a work from one
language to another where one has to choose how to map the concepts behind a
work to the most appropriate concept in a different language. Clearly
translating Jabberwocky into German is creative in a way that compiling the
Linux kernel from C to x86 binary is not.

Interestingly, if you are right, then what online translation services like
babelfish (that allow you to see a web site in another language) do is
probably illegal as they create derivative works without permission of the
copyright holder. It's easy to argue that putting up a web site grants
people implicit permission to copy and render it so that they can see it,
but much harder to argue that it gives them the right to create a derivative
work. (Of course, you could argue fair use.)

As far as I know, no court has addressed this issue. But I think the
sensible thing is to hold that "translation", in copyright law, is meant as
an example of one type of creative process that could create a derivative
work, not that any process that can be argued to be translation (whether
creative or not) automatically makes the result a work for copyright
purposes.

But you never know.

DS


