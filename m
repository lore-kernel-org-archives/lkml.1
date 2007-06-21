Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbXFUCJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbXFUCJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbXFUCJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:09:19 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1055 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbXFUCJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:09:18 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <mdpoole@troilus.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 20 Jun 2007 19:08:37 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEDMEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <87ps3qqi2g.fsf@graviton.dyn.troilus.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 19:09:02 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 19:09:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> By "creative combination" do you mean what US copyright law refers to
> as compilations (or their subset collective works)?

Not only. By "creative combination" I mean either a compilation or a
derivative work. I was a bit unclear about that because I wasn't really
addressing compilation rights at the time.

For example, if you adapt a FreeBSD driver to work on Linux, you may be
creatively combining aspects of the driver with code from the kernel. The
result is one that you have copyright interest in because it is a derivative
work but probably not a compilation copyright. The choice of one driver and
one OS, where the goal is to make the driver work on the OS, probably is not
sufficiently creative to justify a compilation copyright. However, this is
clearly not mere aggregation if significant changes are needed to make the
driver work with Linux.

> Compilations can be creative combinations while still being mere
> aggregation under the GPL.  For example, if applications are selected
> to run with a Linux kernel, and they are distributed together, the
> collection is a creative selection -- and this seems to be one of the
> cases evoked by the GPL's reference to "mere aggregation".  See also
> practically every Linux distribution on the planet.

You are quite correct. In this case, the GPL may not require you to license
the compilation copyright. I believe this is so even if all the works are
covered by the GPL. Arguably, that's a defect in the GPL because it means
there might be situations in which you might receive a CD that contains only
GPL'd software and not be able to redistribute it due to a compilation
copyright.

I honestly have no position on whether "mere aggregation" should include
aggregating works where there is sufficient creative input to justify a
compilation copyright on the result. I think either position can be argued.
I think the intent of the GPL was probably that mere aggregation not include
compilation rights because that leads to strange results. I don't know of
any evidence that compilation rights were considered when the GPL was
written. If so, the deliberate lack of mention might weigh in the balance.

> Compilations also can be creative combinations and *more* than mere
> aggregation: for example, Linux with respect to its subsystems, or any
> case where a larger work is derivative of one of its components.

Of course. If I write a Linux kernel module, it might be a derivative work
because it contains significant portions of the Linux kernel source code.
This is true before anyone compiles it or links it.

When I say linking cannot create a derivative work, I mean assuming the work
was not derivative in the first place. I am also further assuming there is
insufficient creativity in the choice of which works to link to justify a
compilation copyright.

> However, compilations (even to the extent they are creative
> combinations) are not necessarily derivative works of their elements.
> For more details, see
> http://www.copyright.gov/circs/circ14.html#compilations

Because compilation copyrights don't really affect the Tivo and GPLv2/GPLv3
issue, I tend to ignore them when discussing that subject. If you think I'm
wrong and there is some relationship between them, please let me know. I
admit I may not have given that possibility enough thought.

DS


