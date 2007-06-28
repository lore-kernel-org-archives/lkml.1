Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXF1PGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXF1PGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXF1PGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:06:38 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:58129 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbXF1PGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:06:37 -0400
Message-ID: <4683CD9F.5030202@gmail.com>
Date: Thu, 28 Jun 2007 17:02:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Anton Petrusevich <casus@casus.us>
CC: linux-kernel@vger.kernel.org, ALSA user <alsa-user@alsa-project.org>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706281442.05239.casus@casus.us>
In-Reply-To: <200706281442.05239.casus@casus.us>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 02:42 PM, Anton Petrusevich wrote:

Please always use Reply-to-All on this list -- subscribers here like to also 
get personal copies.

> I have ICE1724, a very good sound card to my taste, works like a charm.
> But with ALSA I had a really hard time to configure it properly, wanna
> see my .asoundrc?

Not particularly. I don't count as a great fan of the config file syntax and 
don't use any configuration myself. I moreover don't own an ICE1724 card, so 
I'm not familiar with it's possibilities and quirks and generally, if this 
thread turns into guiding every user on the list through his/her respective 
problems with ALSA I have to respectfully decline...

> And I am not sure I have done it right (== the best possible way). I have
> read everything on http://www.alsa-project.org/documentation.php about
> .asoundrc. When I am using Skype I have to rename .asoundrc to something
> else in order to get it working.

The first thing I don't know is why you need an .asoundrc at all. I've CCed 
the alsa-user list -- some subscribers to it probably have experience with 
ice1724 and might be able to get you specific advice if you want.

Renaming .asoundrc seems wrong in any case. If you need anything special for 
  Skype, it seems you could always define it in a seperate "skype" PCM and 
use that only from skype.

> When I am doing some changes to .asoundrc I have to restart the app.

Yes, as far as I'm aware you do.

> Is there a tool which can be used to configure .asoundrc?

vi.

> I want to be able to hear sound from flashplayer on my reciever or in my 
> headphones -- how?

Not sure? Is your receiver on an analog output and are your headphones 
connected directly to a card output as well? In that case, "or" would seem 
to be just a mixer issue, and "and" would be dependent on hardware abilities 
and needs someone who knows your specific card and setup.

> It's not quite clear to me how to get full duplex working with my
> .asoundrc.

It's not working without an .asoundrc?

But -- I'll personally not continue this very specific subthread simply due 
to not having the hardware, nor great generic experience with an .asounrc 
due to not needing it myself. When I do use one, I alway start by googling 
up a few examples and take it from there. Perhaps someone from alsa-user 
will step in.

Rene.

