Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYHGVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYHGVXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYHGVWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:22:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47391 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYHGVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:22:31 -0400
Date: Thu, 7 Aug 2008 10:18:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jikos@suse.cz
Subject: Re: 2.6.27-rc1: keyboard/mouse gone after s2ram
Message-ID: <20080807081849.GA1688@elf.ucw.cz>
References: <20080805211911.GA1574@elf.ucw.cz> <200808051911.45873.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808051911.45873.dmitry.torokhov@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...on thinkpad x60. I can still use power button to shut the machine
> > down.
> > 
> > s2disk works okay.
> > 
> 
> Does it help if you revert 6aabcdffd1a5f8f5b906696e58069c4f8fced542?
> Can I get a log with i8042.debug please?

It disappeared after 2.6.27-rc2 update. Sorry for noise.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
