Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYGSBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYGSBwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYGSBwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:52:14 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1540 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYGSBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:52:14 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "David@Lang. Hm" <david@lang.hm>
Cc: "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>
Subject: RE: [stable] Linux 2.6.25.10
Date: Fri, 18 Jul 2008 18:51:42 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEJIOEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.DEB.1.10.0807181755590.30465@asgard.lang.hm>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 18 Jul 2008 18:53:53 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 18 Jul 2008 18:53:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Lang wrote:

> > That means only people with the time, energy, and expertise to create an
> > exploit will have an exploit. This includes probably 90% of the
> > people who
> > would use the exploit maliciously

> haven't you ever heard of script-kiddies? they are by far the majority of
> attacks on systems but do not have the expertise to create exploits. it
> takes someone else writing the exploit for them and packaging it to make
> them a threat.

Nobody is saying you should package the exploit. If they need someone else
to package it, they'll still need that. So the question is not if this will
deter script kiddies but whether it will deter the people who package
exploits for them. And from experience, I can tell you that answer is no.
Manys attacks that were believed too difficult for the script kiddies to do
were packaged by people who had the expertise and then used by script
kiddies.

> in the meantime there's a chance for the fix to get propogated out to a
> released version and for people to upgrade their systems. providing
> exploit code along with the bugfix means that the script kiddies have the
> exploit immediatly, but the fix isn't in any released version (not even a
> -rc or daily -git snapshot)

The alternative is that the fix gets released but not implemented.

> > It does, however, ensure that the majority of
> > ordinary users won't be able to test their systems to see if they're
> > vulnerable or if the vulnerability is fixed. So at least it
> > will have some
> > effect.

> how many people run exploits against their production systems to 'see if
> they are fixed', very few, and those only on strict schedules
> with lots of
> adnvance notice and other safeguards.

I can tell you how many run exploits against their production systems when
they don't know the exploits exist -- zero. It takes, at a minimum, the
knowledge that an exploit is possible. In the cases being discussed, even
this was withheld.

Fixes will not be widely deployed on a timely basis unless, at an absolute
minimum, it is known that there is an exploitable bug that has been fixed.

DS


