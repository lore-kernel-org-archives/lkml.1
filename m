Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbXFMNh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbXFMNh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXFMNht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:37:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2825 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752903AbXFMNhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:37:48 -0400
Date: Tue, 12 Jun 2007 15:12:57 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070612151256.GC5986@ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070611120034.f6d972de.akpm@linux-foundation.org> <pan.2007.06.11.19.49.44@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2007.06.11.19.49.44@free.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(please group reply)

> > How does the beep get turned off again?
> May be it is turn off by the speaker driver.
> 
> 
> BTW can't we do something with led ? This way it can be always enabled 
> without anoying people

It would be more complex code, afaict, and ps/2 keyboard may be
absent. But feel free to try, I'm not even sure beeping works
everywhere, so another hack would be nice...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
