Return-Path: <linux-kernel-owner+w=401wt.eu-S1423689AbXEAUhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423689AbXEAUhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423676AbXEAUgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:36:55 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:48902 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423682AbXEAUft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:49 -0400
Message-ID: <4637A4A0.3080909@simon.arlott.org.uk>
Date: Tue, 01 May 2007 21:35:44 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, abraham.manu@gmail.com, xyzzy@speakeasy.org,
       linux-dvb@linuxtv.org, mchehab@infradead.org, mrechberger@gmail.com
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<1178031333.3958.63.camel@localhost> <20070501164054.26090@gmx.net> <20070501183048.268140@gmx.net> <46378BFE.1060009@simon.arlott.org.uk> <20070501193442.272400@gmx.net>
In-Reply-To: <20070501193442.272400@gmx.net>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/07 20:34, Uwe Bugla wrote:
> -------- Original-Nachricht --------
> Datum: Tue, 01 May 2007 19:50:38 +0100
> Von: Simon Arlott <simon@fire.lp0.eu>
>> On 01/05/07 19:30, Uwe Bugla wrote:
>>> <fewer rude comments than usual>
>> If you would avoid making inflammatory comments, the people who are trying
>> to 
>> help you will be more inclined to fix the problems that these patches DO
>> cause 
>> so they can be added.
>>
>> A while ago, you went on and on about your broken floppy drive and how
>> people 
>> shouldn't do things that break other systems - even if they have no idea
>> that 
>> was happening - yet here you are now demanding people do the same thing.
> 
> WRONG!
> I offered a patch for the broken floppy, but Linus was faster and ripped the whole section out, so do not even try to misunderstand or quote me out of context!

You complained that changes which break your system[1] shouldn't be added 
and now rudely demand your desired changes which have been shown to break 
others' should be added immediately. I don't believe I misunderstood you 
or got the wrong context - it has nothing to do with the related patch.

[1] http://lkml.org/lkml/2007/2/25/127


> So I say it again:
> The theses Mr. Chehab invents NOT TO DO SOMETHING do never carry fully transparent information with them. It's just air bubbles that he is producing, nothing else!
> It's always and ever the other part that is exposed to offer transparent info, but never Chehab himself!
> And it's exactly the same thing with Abraham or Krufky!
> 
> And does that behaviour conform with democratic terms? NO WAY!
> So there are three mismatches around: Their names are: Abraham, Krufky, and Chehab!

You're worse than that reiser4 fanatic, at least he wasn't rude when he 
repeated himself over and over and over. I was going to offer to help 
you bisect between -git1 and -git2 (it'd be trivial to run the bisect 
here and provide patches to test) but I won't bother if you're going to 
hijack every email with your abuse.

-- 
Simon Arlott
