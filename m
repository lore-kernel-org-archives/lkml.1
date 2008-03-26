Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYCZW3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYCZW3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYCZW3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:29:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4128 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752887AbYCZW3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:29:39 -0400
Date: Wed, 26 Mar 2008 23:19:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Will Newton <will.newton@gmail.com>
Cc: nitingupta910@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] compcache: compressed RAM block device
Message-ID: <20080326221950.GA4064@ucw.cz>
References: <200803242032.40589.nitingupta910@gmail.com> <87a5b0800803240923m1ec9e343ld08c2828fe42e4e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800803240923m1ec9e343ld08c2828fe42e4e@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  --- /dev/null
> >  +++ b/drivers/block/compcache.c
> >  @@ -0,0 +1,440 @@
> >  +/*
> >  + * Compressed RAM based swap device
> >  + *
> >  + * (C) Nitin Gupta
> 
> Should add a copyright year.

...and GPL.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
