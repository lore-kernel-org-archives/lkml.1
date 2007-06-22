Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXFVCNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXFVCNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 22:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXFVCN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 22:13:29 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2319 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXFVCN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 22:13:28 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 21 Jun 2007 19:13:20 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEKHEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <orir9ghjgh.fsf@oliva.athome.lsd.ic.unicamp.br>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 19:13:40 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 21 Jun 2007 19:13:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 21, 2007, aoliva@redhat.com wrote:

> On Jun 21, 2007, david@lang.hm wrote:

> >> For the record, GPLv2 is already meant to accomplish this.  I don't
> >> understand why people who disagree with this stance chose GPLv2.
> >> Isn't "no further restrictions" clear enough?

> > everyone else is reading this as 'no further license restrictions'

> I didn't see anyone else add "license" where you did.  "No further
> restrictions on the rights granted herein" is very powerful and
> extensive, and that's how it was meant to be.

I agree. For example, a patent might impose a further restriction. The GPL
was clearly meant to foreclose that. There are any number of other ways of
nasty, subtle ways to impose further restrictions, and the GPLv2 meant to
foreclose all of them.

> > not no hardware restrictions' becouse GPLv2 explicitly says that it
> > has nothing to do with running the software, only with distributing
> > it.

> It also says that running the software is not restricted, and since
> copyright law in the US doesn't regulate execution, receiving the
> software does grant the recipient the right to run the software.  So
> the distributor can't impose restrictions on it.

Right.

The response to this argument is that it is mind-bogglingly obvious that the
GPL doesn't mean that no *authorization* decisions can stand in your way. It
didn't mean that I couldn't keep the root password to my server secret even
though that denies you the "right" to modify the Linux kernel running on it.

Some entity has to decide what software runs on any particular piece of
hardware, and it was never the intent of the GPL to specify or limit who
that person was. This has been discussed many times over many years, longer
before Tivoization was even thought of, and it was agreed that the GPL
didn't foreclose authorization obstacles to software modification.

Why doesn't Linux allow a non-root user to install a module or change which
kernel the system runs? Doesn't that limit the GPL rights of all non-root
users to modify the GPL'd kernel software on that machine? OF COURSE NOT.

DS


