Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbYBHATb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbYBHATb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYBHATT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:19:19 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2996 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYBHATS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:19:18 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Cc: "Chris Friesen" <cfriesen@nortel.com>, "Greg KH" <greg@kroah.com>,
       "Christer Weinigel" <christer@weinigel.se>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only
Date: Thu, 7 Feb 2008 16:18:05 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEMOKCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <47AB06F9.30201@davidnewall.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 07 Feb 2008 16:19:29 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 07 Feb 2008 16:19:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Don't ignore, "mere aggregation of another work not based on the Program
> with the Program (or with a work based on the Program) on a volume of a
> storage or distribution medium does not bring the other work under the
> scope of this License."  Static linking certainly makes something part
> of the whole; dynamic linking doesn't.

Actually, static linking does not, since the whole is not a "work". Under copyright law, a "work" can only be made by creative effort. Static linking is not creative effort, so it cannot create a work. If it were, the linker would be entitled to copyright on the new work, which makes no sense at all.

An exception might exist if there were a large number of equally good ways to perform the link and the person who lined it had to creatively chose a method. But normally, anything purely dominated by functional considerations (which statically linking almost always is) is not considered sufficiently creative.

If you statically link work "X" to work "Y", the result is *not* work "Z", derivative from "X" and "Y". It is parts of work "X" and parts of work "Y" mechanically combined. A group of combined works follows the license for each of the individual works from which sufficient protectable expression has been taken.

A "derivative work" is a new work, and can only be formed by creative effort not in the works it is claimed to be derivative of.

And to Alan Cox, who write:

> First mistake: The GPL is not a contract it is a license.

A license is a form of contract in which part of the compensation one party receives is rights to the intellectual property of the other party.

>If the GPL was a contract it could most certainly impose conditions upon
>original works. Contract law permits to write things like "If you buy the
>source for this package you agree not to write a competing product for
>three years even if an origina work". 

Sure, and those things would apply to anyone who has accepted the contract. Why do you think the GPL couldn't say those things and enforce them against anyone who had agreed to the GPL?

How is agreeing to release source code any different from agreeing not to write a competing product? (Except that a court may be more likely to enforce the latter than the former, of course.)

And to Marcel:

> so how do you build this module that is not linked without using the
> Linux kernel. Hence derivative work. Hence dynamic linking at runtime of
> binary only code is violating the GPL.

When there is only one way to do it, you cannot copyright that one way. You need a patent for that. So, no, it's not a derivative work because what was taken is the one way to do it, and "one way to do it" is not protectable expression. A derivative work only applies when protectable expression is taken.

DS


