Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbXF1Qe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbXF1Qe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXF1QeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:34:21 -0400
Received: from mg.nix.la ([75.126.232.227]:43407 "EHLO mg.nix.la"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308AbXF1QeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:34:20 -0400
From: Anton Petrusevich <casus@casus.us>
To: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Thu, 28 Jun 2007 18:34:16 +0200
User-Agent: KMail/1.9.7
References: <200706281442.05239.casus@casus.us> <4683CD9F.5030202@gmail.com>
In-Reply-To: <4683CD9F.5030202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281834.16564.casus@casus.us>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007 17:02:55 you wrote:
> Please always use Reply-to-All on this list -- subscribers here like to
> also get personal copies.

I am not subscribed to linux-kernel, I am reading it on the web.

> > I have ICE1724, a very good sound card to my taste, works like a charm.
> > But with ALSA I had a really hard time to configure it properly, wanna
> > see my .asoundrc?
> Not particularly. I don't count as a great fan of the config file syntax
> and don't use any configuration myself. 

Do you have an SPDIF out? If you don't then you don't need .asoundrc of 
course.

> The first thing I don't know is why you need an .asoundrc at all. 

Because I want to route it differently, sometimes to spdif, sometimes to 
headphones, sometimes to mix sounds from different apps. Well, my config may 
be a bit ancient as it was written when dmix was not default.

> I've CCed 
> the alsa-user list -- some subscribers to it probably have experience with
> ice1724 and might be able to get you specific advice if you want.

I have read some advices for ice1724 already. The main reason I wrote to  
lkml -- I hate .asounrc and reading docs about it. I hate "flexebility" that 
requires restarting apps after changing sound routes.

> > Is there a tool which can be used to configure .asoundrc?
> vi.

I perfectly know this one. I would like to use some really user-friendly tool.

>
> > I want to be able to hear sound from flashplayer on my reciever or in my
> > headphones -- how?
>
> Not sure? Is your receiver on an analog output and are your headphones

My receiver is on spdif out.

> connected directly to a card output as well? In that case, "or" would seem
> to be just a mixer issue, and "and" would be dependent on hardware
> abilities and needs someone who knows your specific card and setup.
>
> > It's not quite clear to me how to get full duplex working with my
> > .asoundrc.
>
> It's not working without an .asoundrc?

Looks like it's not working with. As skype is not so informative.

> But -- I'll personally not continue this very specific subthread simply due
> to not having the hardware, nor great generic experience with an .asounrc
> due to not needing it myself. When I do use one, I alway start by googling
> up a few examples and take it from there. Perhaps someone from alsa-user
> will step in.

I am not about ice1724 or .asounrc here. I am trying to talk about 
user-friendliness of ALSA. It's very unfriendly.

-- 
Anton Petrusevich
