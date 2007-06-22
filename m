Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXFVV2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXFVV2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXFVV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:28:14 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1542 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbXFVV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:28:12 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <alan@lxorguk.ukuu.org.uk>
Cc: <aoliva@redhat.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Fri, 22 Jun 2007 14:28:11 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEPLEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070622100535.0e431149@the-village.bc.nu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 22 Jun 2007 14:28:36 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 22 Jun 2007 14:28:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > It's this simple, those who chose the GPLv2 for Linux and their
> > contributions to it don't want people to create derivative
> > works of their
> > works that can't be Tivoized. They see this as a feature, and it's the

> Untrue. Many of us think (and the lawyers are unsure) that it is covered
> by GPLv2 anyway. Some drivers actually make this clear in their comments
> about intepretation

I didn't mean to speak for every single contributor to Linux. I apologize if
I gave that impression.

Lawyers are almost always unsure of things that aren't well-settled. It's
practically a job requirement. However, I think that view is so incredibly
bizarre that I can't imagine anyone taking it seriously. Not even the FSF
agrees with it, and they have taken insanely expansive views of the scope of
the GPL.

If the GPLv2 says you can't Tivoize, then Linus is violating the GPL by
withholding the keys he uses to sign the Linux kernel source release. No
rational argument would defend one point and not the other (unless you add
crazy ad-hocery with no support in law or common sense). If you are one of
those people, please be consistent and condemn Linus' refusal to release his
signing keys and thus "Tivoizing" the Linux kernel.

Don't even try to make some kind of counter-argument about signatures that
are or aren't functional. Functionality would *exempt* things from copyright
coverage, not subject them to it. (And Linus' signature *is* functional.
People use it to decide whether or not to run the code. It serves no other
purpose than that. Some people will only run kernel code signed by Linus,
and my not having his signing key means that my changes can't be run on
machines controlled by those people.)

DS


