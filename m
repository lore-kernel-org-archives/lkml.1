Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXIQPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXIQPVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXIQPVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:21:43 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1984 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXIQPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:21:42 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Theodore Tso" <tytso@mit.edu>, "Krzysztof Halasa" <khc@pm.waw.pl>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       <misc@openbsd.org>, <linux-kernel@vger.kernel.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Eben Moglen" <moglen@softwarefreedom.org>,
       "Lawrence Lessig" <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       "Matt Norwood" <norwood@softwarefreedom.org>
Subject: RE: Wasting our Freedom
Date: Mon, 17 Sep 2007 08:20:39 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEJFGNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <m36429wgvl.fsf@maximus.localdomain>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 08:21:23 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Sep 2007 08:21:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Theodore Tso writes:

> Now, you don't need a licence from the original author to use
> the derived work. The author of the derived work only needs
> a licence from the original author to create a derived work.
> Do you think Microsoft users have licences from authors of
> the works MS Windows etc. are based on? :-)

Of course you don't need a license to *use* the derived work. You never need
a license to use a work. (In the United States. Some countries word this a
bit differently but get the same effect.)

If, however, you wanted to get the right to modify or distribute a
derivative work, you would need to obtain the rights to every protectable
element in that work. If the work were under a GPL or BSD type license, only
the original author of each individual element could grant you such a
license.

Read GPL section 6, particularly this part: "Each time you redistribute the
Program (or any work based on the Program), the recipient automatically
receives a license from the original licensor to copy, distribute or modify
the Program subject to
these terms and conditions."

To distribute a derivative work that contains protectable elements from
multiple authors, you are distributing all of those elements and need the
rights to all of them. You need a license to each element and in the absence
of any relicensing arrangements (which the GPL and BSD license are not),
only the original author can grant that to you.

It is a common confusion that just because the final author has copyright in
the derivative work, that means he can license the work. He cannot license
anyone else's creative contributions absent a relicensing arrangement.

The GPL is explicit that it is not such a license. That's what the "from the
original licensor" language in section 6 means. The BSD license is not
explicit, but it couldn't work any other way.

When you receive a Linux kernel distribution, you receive a GPL license to
every protectable element in that work from that element's individual
author. Nobody can license the kernel as a whole to you.

DS


