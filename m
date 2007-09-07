Return-Path: <linux-kernel-owner+w=401wt.eu-S965489AbXIGMCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbXIGMCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 08:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXIGMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 08:02:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4494 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965251AbXIGMCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 08:02:41 -0400
Date: Fri, 7 Sep 2007 12:02:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fujtisu application panel driver
Message-ID: <20070907120220.GB3901@ucw.cz>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <d120d5000707021216y1a3641b1rbc0c741e2d7d4e70@mail.gmail.com> <20070903095847.72245af4@oldman>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903095847.72245af4@oldman>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Thank you very much for updating the patch. I have a couple of requests though:
> > 
> > 1. LEDs shoud use the generic led subsystem instead of input layer. I
> > do not have plans of adding any more LED_XXX constants and I think
> > that adding any LEDs not directly relating to keyboard state was a
> > mistake.
> 
> No, way to much work for one stinking LED.

'Lets do it wrong way because right way is too much work'?

Come on... doing let driver is 30 minutes and 100-or-so lines of code.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
