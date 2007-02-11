Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXBKXYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXBKXYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932591AbXBKXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:24:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53738 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932570AbXBKXYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:24:05 -0500
Date: Mon, 12 Feb 2007 00:23:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070211232338.GH15445@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <20070211210258.0b8da53c@localhost.localdomain> <1171235428.4493.105.camel@nigel.suspend2.net> <200702120016.18480.rjw@sisk.pl> <1171236143.4493.118.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171236143.4493.118.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > - built in;
> > > - modular, loaded while suspending but not loaded prior to resume from
> > > disk;
> > > - modular, loaded while suspending and loaded prior to resume from disk;
> > 
> > I think we should state the general rule in Documentation/SubmittingDrivers
> > and give more details in Documentation/power/devices.txt
> 
> Sounds good.

Ok, so who does the patch?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
