Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbXFKR3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbXFKR3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXFKR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:28:55 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:50700 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXFKR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:28:54 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 13:28:54 EDT
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
References: <878xb3l888.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl>
	<87odjz9qo9.fsf@jbms.ath.cx> <200706020233.44509.rjw@sisk.pl>
	<87k5un9l4n.fsf@jbms.ath.cx>
	<1181533248.17758.55.camel@nigel.suspend2.net>
	<87abv6o7qo.fsf@jbms.ath.cx>
	<1181576723.11365.45.camel@frg-rhel40-em64t-04>
	<87r6oimqva.fsf@jbms.ath.cx>
	<1181577808.11365.49.camel@frg-rhel40-em64t-04>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 11 Jun 2007 13:05:09 -0400
In-Reply-To: <1181577808.11365.49.camel@frg-rhel40-em64t-04> (Xavier Bestel's
	message of "Mon\, 11 Jun 2007 18\:03\:28 +0200")
Message-ID: <87myz6mnga.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> writes:

[snip]

> If I were helping you coding I'd suggest to only concentrate on having
> your project work on standard filesystems, and then when it works maybe
> think about suspending on crypto-over-loop-over-fuse-over-vpn-over-wifi.
> But talk is cheap so I'm shutting up. Right now. :)

Well, the whole idea of the kexec approach is that the hibernate system
doesn't need to know anything at all about filesystems or any particular
device.  So if it works at all, it will work for
crypto-over-loop-over-fuse-over-vpn-over-wifi
-over-pigeon-carrier-protocol-over-printer-and-scanner.

-- 
Jeremy Maitin-Shepard
