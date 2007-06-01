Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXFAHeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXFAHeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXFAHeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:34:14 -0400
Received: from smtp-out4.iol.cz ([194.228.2.92]:53422 "EHLO smtp-out4.iol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXFAHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:34:13 -0400
Message-ID: <465FCBD5.3040908@volny.cz>
Date: Fri, 01 Jun 2007 09:33:41 +0200
From: Bill Eldridge <dcbill@volny.cz>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org,
       linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-dvb] dst customization patchset
References: <20070530211826.276640@gmx.net>	<e0b07cc80705301808j697b816bibbbc0ed5742a69b8@mail.gmail.com>	<465E56AB.1000905@volny.cz> <200705311541.41710.uwe.bugla@gmx.de> <d9def9db0705311503i3531b775p9cc226b81a547499@mail.gmail.com>
In-Reply-To: <d9def9db0705311503i3531b775p9cc226b81a547499@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sounds good, Markus - do you have a list of known bugs that need to be 
handled?
Is this something that can go up on the Wiki, or are there enough that a 
bug tracking
system is required?

While timelines won't be enforceable for people doing things in their 
spare time, it's
still useful to put up time goals and priority lists on projects, both 
new development and
bug fixes, to keep momentum going and gauge progress, including seeing 
that something
that should have been fixed isn't getting handled.

Can people accept Markus as a reasonable, informed arbiter of what will 
go into the main tree
even if there are disagreements? It also sounds like new programmers 
here  need more startup
instructions/assistance/advice and ground rules than on many open source 
projects.

Regards,
Bill

Markus Rechberger wrote:
>
> Some developers are also sick of contributing since the whole
> community is flawed at the moment. I propose a few ways to go
>
> * stopping that signed off by madness that every driver developer has
> to sign off changes which happened at the core which will definitelly
> never happen because people _do not like each other_.
>
> * change the maintainership and push it over to me, even if it sounds
> selfish at the moment _every_ code which provides additional features
> and where noone expects further improvements within the next few weeks
> (without throwing away alot of work or generating useless extra work
> by telling someone to rewrite the core of his work); everyone still
> can try to write better code - but then he _has to do it completly_
> and get in peace with the projects by supporting them to get further.
>
> The problem I have with this project is that many more things are
> upcoming at the moment (including bug fixing) but there are certain
> developers which first weren't experienced enough, afterwards started
> to think about the issues which were tried to discuss at the beginning
> already and who don't have an overview about the requirements, neither
> do they want to discuss the requirements.
> I can name numerous of bugs of this project which can be solved but
> which just get ignored. Some known bugs dont even get explained to
> people who are interested in fixing them, so this is what I consider
> that it's a major problem.
>
> I'm looking for a serious discussion about it, if anyone wants to know
> about the history I can point out to many logfiles/older emails which
> deeply explain the whole video4linux/dvb issues - the project should
> turn back to a real community.
>
> Markus
>   



