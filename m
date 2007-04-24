Return-Path: <linux-kernel-owner+w=401wt.eu-S1423070AbXDXTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423070AbXDXTgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423072AbXDXTgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:36:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46425 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423070AbXDXTgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:36:18 -0400
Date: Tue, 24 Apr 2007 21:36:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070424193607.GB16503@elf.ucw.cz>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net> <20070412204413.GA3151@zarina> <20070413005112.GA20890@khazad-dum.debian.net> <20070413021550.GA15790@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413021550.GA15790@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > That said, you may need to use uWh and uAh instead of mAh and mWh, though.
> > > 
> > > Not sure. Is there any existing chip that can report uAh/uWh? That is
> > > great precision.
> > 
> > The way things are going, it should be feasible for small embedded systems
> > quite soon.  Refer to the previous thread.
> 
> I see... is it also applicable to currents and voltages? I.e. should we
> use uA and uV from the start?

AFAICT, mobile phone in standby can eat less than 1000 uW... so uA/uV
would indeed be nice.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
