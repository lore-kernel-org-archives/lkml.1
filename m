Return-Path: <linux-kernel-owner+w=401wt.eu-S1422905AbXBPAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905AbXBPAjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXBPAjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:39:24 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4443 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422905AbXBPAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:39:23 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <trent.waddington@gmail.com>
Cc: "Neil Brown" <neilb@suse.de>, <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Thu, 15 Feb 2007 16:38:41 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEBDBKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <3d57814d0702151351i544f9efdh6c7dfc8be5a35c69@mail.gmail.com>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 15 Feb 2007 16:38:57 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 15 Feb 2007 16:38:58 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I must have missed something, who is trying to coerce people into not
> exercising the rights the GPL gave them?

Anyone who claims that it is unlawful to "circumvent" the EXPORT_SYMBOL_GPL
stuff. Anyone who adds copyright or license enforcement mechansims to GPL'd
code and distributes the result. Anyone who tries to frighten people into
openening their code based on a crazy notion of what constitutes a
derivative work. Anyone who tries to use copyrights as if they were patents
and claims they can own *every* *way* to do a particular thing. (Especially
if those same people *oppose* software patents!)

> I don't debate that people
> are trying to coerce people into passing on the rights the GPL gave
> them when they distribute the kernel... coercion, that's what software
> licenses are.  Who's changing the rules?

Anyone who adds a mechanism to the Linux kernel, distributes the result, and
then argues that one is subjected to new restrictions on how you can modify
and distributed GPL'd works (restrictions not found in the GPL) as a result
of the code that they added.

Just to be perfectly clear, it is an outrageous claim that *every*
*possible* kernel module must be a derivative work of the kernel. Copyright
*cannot* protect every possible way to accomplish a particular function (and
"a Linux driver for the X800 graphics chipset" is a function). Copyright can
*only* protect the one possible way you chose to do something out of a large
number of equally good possible ways. (See, for example, Lexmark v. Static
Controls where courts held that Static Controls could take Lexmark's TLP
software because that was the only practical way to make a compatible toner
cartridge.)

This is an absurd claim.

DS


