Return-Path: <linux-kernel-owner+w=401wt.eu-S1764817AbXFSDXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764817AbXFSDXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762585AbXFSDW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:22:59 -0400
Received: from smtp161.iad.emailsrvr.com ([207.97.245.161]:37415 "EHLO
	smtp161.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918AbXFSDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:22:58 -0400
Message-ID: <46774BD3.6010605@gentoo.org>
Date: Mon, 18 Jun 2007 23:21:55 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Alexandre Oliva <aoliva@redhat.com>
CC: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net>	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070615072322.GA7594@brong.net>	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070616021630.GA30660@brong.net>	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070616103130.GD32405@brong.net>	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>	<20070616233251.GA17270@brong.net> <ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let's take a certain class of medical devices into account: ones that 
are absolutely definitely for medical treatment, but are not life 
threatening if they fail.

Say, a dental treatment device -- if the device produces a crown or 
bridge that doesn't fit properly, the dentist says "nope" and throws it 
away. No harm done.

Alexandre Oliva wrote:
> There may be business models that require the ability to make changes.

I'd say that its sensible for the manufacturer to attempt to retain this 
ability in every case. You never know what's going to go wrong, so it's 
a plus to have this option so that you can roll out some types of fixes 
without going bankrupt.

Now, for medical devices, this is tricky stuff: medical devices require 
all sorts of certifications, so modifying your product after you have 
certified it has it's complications. However, despite all the 
regulations it's realistic to be able to do this, and it does happen. 
Hell, windows-based devices in this field download new antivirus 
definitions and run windows update every few days.

> Then it's fair to enable the user to make changes as well, such that
> they don't become dependent on the vendor

Now this is where the regulations get really heavy. If the user is 
offered the ability to modify the device, theres *no way* it would get 
certified. Your business is dead - you do not have a product you can 
sell. In such case, the license has completely excluded free software 
from the market and everyone is forced to use completely closed systems.


I realise that the latest GPLv3 draft would not pose restrictions here, 
as such devices would not be classified as consumer products. That said, 
talking purely in terms of business models and fairness: there ARE 
decent reasons for manufacturer lockdown in some industries.

Daniel
