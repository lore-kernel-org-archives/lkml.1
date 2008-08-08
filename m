Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYHHMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYHHMe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbYHHMes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:34:48 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36081 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYHHMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:34:48 -0400
Message-ID: <489C3D67.2070207@keyaccess.nl>
Date: Fri, 08 Aug 2008 14:34:47 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Press, Jonathan" <Jonathan.Press@ca.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux	interface	for
 on access scanning
References: <20080804223249.GA10517@kroah.com>	<1217896374.27684.53.camel@localhost.localdomain>	<20080805005132.GA3661@kroah.com>	<20080805122328.69a37c1d@lxorguk.ukuu.org.uk>	<20080805170307.GB9639@kroah.com>	<1217962602.27684.144.camel@localhost.localdomain>	<20080805203007.GB27489@kroah.com>	<1218048597.27684.276.camel@localhost.localdomain>	<20080806210202.GA9413@mit.edu>	<1218058081.5837.49.camel@localhost.localdomain>	<20080806215244.GA21462@mit.edu>	<1218118603.5837.101.camel@localhost.localdomain>	<489BAA25.3030004@keyaccess.nl><1218161738.5837.218.camel@localhost.localdomain> <489BB5BE.20602@keyaccess.nl> <2629CC4E1D22A64593B02C43E855530304AE4B37@USILMS12.ca.com>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4B37@USILMS12.ca.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-08-08 13:58, Press, Jonathan wrote:

> Just an observation about this...
> 
> Since I earn my living on the basis of users, clueless or not, I've
> gotten into the habit of just taking them as they come and trying to go
> out of my way to not refer to them as clueless -- except in a few
> specific and particularly annoying cases.

You say that as though you feel that calling someone clueless were a bad 
thing. There are tons of subjects I'm completely and utterly clueless 
about and very happily so. But, as you say, that's not the point...

> But that's not my point.  My point is that Linux has become a
> commercially viable environment with a lot of enterprise users, with a
> significant number of enterprises are standardizing on it, or at least
> officially supporting/allowing/encouraging its use.  Because of that,
> for example, we have a significant number of user issues coming in that
> indicate that there are actually plenty of clueless Linux users, whether
> the OS was intended for them or not.

But not users with root access, which is the context in which my own 
remark was. Enterprise users in corporations are not what I call the 
desktop; I'd generally call those workstations, with the desktop being 
your average home PC with the enormous amounts of cheap and buggy 
hardware and the definite lack of central IT management.

It's also dependent on country. Over here in the Netherlands, corporate 
adoption "on the workstation" is very low (and seemingly dropping again 
after some initial attempts in local government) and adoption on the 
desktop is for all intents and purposes 0. It's different especially in 
eastern-europe.

Funny that really, how all that Free as in Speech stuff mostly works for 
people without money...

> The fact that they are there is the main reason that Red Hat and Novell,
> for example (at least by my observation from the outside -- I can't
> speak at all about how they see if from the inside) seem to be putting
> the bulk of their efforts into their enterprise editions, as opposed to
> their traditional technologist editions.
> 
> The bottom line, then, is that there ARE way more clueless Linux users
> out there than there used to be, which makes them a) vulnerable to
> losses by virtue of their own mistakes, and b) vectors for the spread of
> malware.  Which is kind of why we're here.

Right, so that, then, is a threat model. I myself believe you are here 
mostly to guard against 11-year old girls installing infected 
screensavers of horses which given the fairly low adoption of Linux by 
11-year old girls says something about my view of things.

But, yes, as I myself said as well, it might be sensible to discuss this 
issue simply _as if_ lots of users were brushing their My Little Pony's 
while waiting for their kernels to finish compiling if you're designing 
something that _should_ protect them if they were.

Goes back really to the threat model question you were asked I guess.

Rene.
