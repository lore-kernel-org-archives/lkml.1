Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZBMJiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZBMJiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZBMJhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:37:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42985 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZBMJhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:37:50 -0500
Date: Fri, 13 Feb 2009 10:37:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: ACPI: S4 disappeared [mmotm 2009-02-10-16-35]
Message-ID: <20090213093749.GA29550@atrey.karlin.mff.cuni.cz>
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <499291A3.9070501@gmail.com> <4992A59F.5090502@gmail.com> <200902111643.10191.rjw@sisk.pl> <20090211162247.GA32301@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211162247.GA32301@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------------->
> From 17993b49b1f540aace8e9b4242530d0b3376eb2a Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 11 Feb 2009 17:20:51 +0100
> Subject: [PATCH] x86: make hibernation always-possible
> 
> This commit:
> 
>   aced3ce: x86/Voyager: remove HIBERNATION Kconfig quirk
> 
> Made hibernation only available on UP - instead of making it available
> on all of x86. Fix it.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

ACK.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
