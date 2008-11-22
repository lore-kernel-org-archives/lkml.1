Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYKVSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYKVSst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 13:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKVSsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 13:48:40 -0500
Received: from mx.treblig.org ([80.68.94.177]:41111 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYKVSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 13:48:39 -0500
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2008 13:48:39 EST
Date: Sat, 22 Nov 2008 18:16:19 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Fredrik Markstr?m <fredrik.markstrom@avalonenterprise.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
Message-ID: <20081122181619.GA7381@gallifrey>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com> <4922ED5A.3030808@shaw.ca> <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.23.1-bytemark-uml (i686)
X-Uptime: 18:12:48 up 48 days, 8 min,  2 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fredrik Markstr?m (fredrik.markstrom@avalonenterprise.com) wrote:
> Thanks for the prompt respons.
> 
> I do agree that it would be better for everyone to release it under
> GPL and I have already expressed that to our customer.
> 
> At this point I feel that we have two possibilities, help our customer
> violate GPL or say no to the project. I'd prefer a third option where
> I could tell the customer that we can setup the project in a certain
> way (some "cleanroom" setup ?) to ensure that the results can not be
> considered derived work.

A 3rd option I think would be for them to put the bits that they worry about
the IP in firmware executed in a processor on the ether chip, then make
a nice clean interface that a GPL'd driver talks to.

Of course that relies on there being a suitable processor in the
chip; if not then perhaps you should remind them to think about
the software before spinning their chip!

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
