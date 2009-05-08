Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZEHBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZEHBda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZEHBdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:33:20 -0400
Received: from mail.crca.org.au ([67.207.131.56]:39264 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZEHBdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:33:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090507215112.GC14611@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507120948.GA1531@ucw.cz> <200905071942.54936.rjw@sisk.pl>
	 <20090507215112.GC14611@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 08 May 2009 11:34:19 +1000
Message-Id: <1241746459.19600.246.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > On Thursday 07 May 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > it can be merged) and the willingness of those who matter.
> ...
> > > To summarise disadvantages:
> > > 
> > > - only core has 8000 LoC
> > > - it does stuff that can be easily done in userspace
> > >      (and that todays distros _do_ in userspace).
> > > - it duplicates uswsusp functionality.
> > > - compared to [u]swsusp, it received little testing
> > 
> > Actually, I see advantages of working together versus fighting flame wars.
> > Please stop that, I'm not going to take part in it this time.
> 
> Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> 
> If we are talking about improving mainline to allow tuxonice
> functionality... then yes, that sounds reasonable.

I'd like to see use have all three for one or two releases of vanilla,
just to give time to work out any issues that haven't been foreseen.
Once we're all that there are confident there are no regressions with
TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.

Regards,

Nigel

