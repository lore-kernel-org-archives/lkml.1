Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXISNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXISNvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXISNvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:51:15 -0400
Received: from smtpoutm.mac.com ([17.148.16.74]:62235 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbXISNvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:51:14 -0400
In-Reply-To: <alpine.LFD.0.999.0709191704300.7162@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com> <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com> <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in> <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com> <alpine.LFD.0.999.0709191704300.7162@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DBAB3583-BB6E-48C8-AFC1-0A705D048843@mac.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NFS4 authentification / fsuid
Date: Wed, 19 Sep 2007 09:49:43 -0400
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 19, 2007, at 08:16:30, Satyam Sharma wrote:
> [all sorts of crap about spies in washington needing stronger  
> protection than your average consumer]

Well no duh.  I think most of the 4-year-olds I know could have told  
you that.  What sense does it make to give a spy all sorts of fancy  
electronic listening and monitoring equipment and then rely on the  
physical security of your average Dell?  You _can_ make a laptop  
sufficiently secure that its data is encrypted and it cannot be  
physically compromised to install a hardware keylogger without  
virtually destroying the enclosure, but that's completely unnecessary  
for 99.99999% of the users on the planet.

We would be much better off if all the companies getting their data  
stolen out from under them on company laptops would just use basic  
drive encryption and implement basic physical-security training.   
*THAT* is where protecting the laptop is easy; all the bullcrap about  
foreign intelligence is just drawing focus off of how easy it is to  
achieve *adequate* physical protection where it matters.

 From a practical standpoint, an identity thief trying to determine  
which company to attack will just steal a few laptops from a company  
which doesn't encrypt them instead of going through all the very  
risky steps of trying to break into the laptops of one that does.

Of course, this also relies on being able to teach the stupid lusers  
with the laptops not to give their boot password to the "service tech  
on the phone"


>> If your system equates end-user with attacker
>
> "If"? Was there ever any doubt?
>
> Heh, did you even read the thread you just replied to?

Yes I did and I wanted to make it *really* clear that with average  
hardware you can properly protect against virtually all of the  
*common* attack vectors.  The pretty standard problems of "somebody  
stole the company laptop with a bunch of credit-card info on it" or  
"my personal financial data was on the laptop I left in the airport",  
are pretty easy to make safe.  Furthermore, that is *EXACTLY* the  
initial example I gave (my laptop with my personal data on it).


On the other hand, I made this point in my original email, so if this  
is what you were arguing about you've been preaching to the choir.

> We're talking of consoles / hardware sold by commercial companies  
> to  users here, where they want explicitly want to prevent the  
> users from  being able to hack it. So yes, end user == attacker.
>
>> then you are *screwed* regardless!
>
> Ah, finally you make my point again for me :-)


To quote myself again:
> A fully self-certifying system that can prevent any attack is  
> impossible to achieve.  If I have the device and can devote as many  
> hours as I want to breaking into it, there is exactly ZERO way to  
> prevent that, aside from encrypting things and not giving out the  
> key (which sorta makes it useless but is precisely the point of  
> real crypto).
>
> There is a HUGE difference between "I don't want the end-user to  
> hack into this" and "The end-user wants a certain degree of  
> assurance that his data can't be compromised.


Cheers,
Kyle Moffett

