Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXGEADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXGEADT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbXGEADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:03:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41196 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756325AbXGEADG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:03:06 -0400
Date: Thu, 5 Jul 2007 02:03:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705000301.GE2719@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031454.42078.nigel@nigel.suspend2.net> <1183441706.10386.73.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183441706.10386.73.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So I think Matthew is totally right. In fact, the presence of the
> freezer is the main reason why Paulus so far NACKed Johannes attempts at
> merging the PPC PM code with the generic code in kernel/power.c
> 
> We've been doing fine without it so far and intend to continue to do
> so.

How well does it work on SMP PPC?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
