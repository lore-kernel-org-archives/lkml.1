Return-Path: <linux-kernel-owner+w=401wt.eu-S935457AbXJQUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457AbXJQUyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbXJQUyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:54:41 -0400
Received: from khc.piap.pl ([195.187.100.11]:50698 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbXJQUyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:54:40 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 17 Oct 2007 22:54:36 +0200
In-Reply-To: <47166C83.2050207@s5r6.in-berlin.de> (Stefan Richter's message of "Wed, 17 Oct 2007 22:11:47 +0200")
Message-ID: <m38x614g37.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> What I meant was:  First revisions may have had incomplete OHCI 1.1
> support and were sold as OHCI 1.0 chips, and as soon as they stabilized
> it they sold them as OHCI 1.1 chips.  But that's mere speculation on my
> part.  I can't think of any other reason though why anybody would hide
> OHCI 1.1 compatibility.

Perhaps some MS Windows had troubles with 1.1?
VIA has a history of similar things (e.g. some C3 CPUs).

All 3 chips I have, including that dated 2002, are single
revision "80" so I guess there are absolutely no silicon changes.

> And are you going to test if and how stable OHCI 1.1 features work?
> (Which features are these?  Right now only dual buffer reception comes
> to my mind.)

On this old EPIA? No :-)
At least unless I have any doubt.

On the other machine (currently) 1.0? Sure, that's why I did it.
Is the "dual buffer reception" involved in receiving video from
a DV camera, using the new driver?
-- 
Krzysztof Halasa
