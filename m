Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbXFPCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbXFPCNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbXFPCNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:13:15 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2882 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbXFPCNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:13:14 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 19:13:00 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEDDEKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEPOEJAC.davids@webmaster.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 15 Jun 2007 19:13:38 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 15 Jun 2007 19:13:38 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


By the way, the unfortunate answer to the question of what the default
position is when contributions to a collective work are received without
explicit license, at least in the United States, is:

"In the absence of an express transfer of the copyright or of any rights
under it, the owner of copyright in the collective work is presumed to have
acquired only the privilege of reproducing and distributing the contribution
as part of that particular collective work, any revision of that collective
work, and any later collective work in the same series." -- USC 201(c)

That is, as I understand the law, if you receive a contribution to a project
without any specific license in that contribution, it works like this:

1) You automatically receive a license to use that piece as part of that
project by virtue of the fact that it was contributed by the author to that
project. (Because 210(c) says so.)

2) If the contribution is itself a derivative work of a GPL'd work, then you
receive a GPL license. (Because the GPL says so).

So it would be very unwise to add a contribution that wasn't itself a
derivative work without clear indication from the author that the
contribution is offered under the license you need. I had assumed no law set
a default, and therefore the default would be the project's license. THIS IS
INCORRECT. 201(c) sets the default, and it's the wrong one.

This means that contributions of non-derivative works to GPL projects should
not be added to the project unless the author specifically licenses that
piece under the GPL. I would not consider it safe to assume that the fact
that the author knowingly contributed the work to a GPL'd project is
sufficient to change the 201(c) default.

What's worse, section 203 appears to grant the author various ways, by law,
to *terminate* a license grant. This termination removes the ability to
create subsequent derivative works. Ouch.

http://www.copyright.gov/title17/92chap2.html

I sure hope I'm misunderstanding something.

DS


