Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYIIQyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYIIQyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYIIQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:54:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59330 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbYIIQyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:54:39 -0400
Date: Tue, 9 Sep 2008 18:55:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Re: Controlling backlight on thinkpad x60
Message-ID: <20080909165558.GB1691@elf.ucw.cz>
References: <20080908151058.GA1650@elf.ucw.cz> <20080908155457.GA30619@srcf.ucam.org> <20080909152859.GA1813@elf.ucw.cz> <20080909164254.GA25463@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909164254.GA25463@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-09-09 17:42:54, Matthew Garrett wrote:
> On Tue, Sep 09, 2008 at 05:29:00PM +0200, Pavel Machek wrote:
> > That's bad then, because ACPI video support does not work here. I can
> > boot, and even Fn-home/end works, but it breaks with X.
> > 
> > In old versions, it resulted on black screen after LID close in X.
> 
> Yeah, X did retarded things in response to video events. That's been 
> fixed for ages.
> 
> > In 2.6.27-rc5, screen goes black as soon as X are started.
> 
> That sounds bizarre, and I can't reproduce it here.

It was same old X. New X fix that. But I still have two backlight devices...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
