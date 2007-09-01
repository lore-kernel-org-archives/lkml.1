Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbXIAWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbXIAWDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXIAWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:03:34 -0400
Received: from ebb.errno.com ([69.12.149.25]:4403 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbXIAWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:03:33 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 18:03:32 EDT
Message-ID: <46D9E1B8.2060300@errno.com>
Date: Sat, 01 Sep 2007 15:03:36 -0700
From: Sam Leffler <sam@errno.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070814)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Fwd: That whole "Linux stealing our code" thing
References: <200709010140.l811eq9H005896@cvs.openbsd.org> <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com> <46D99FB7.6030505@garzik.org> <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com> <20070901205457.GK9260@stusta.de>
In-Reply-To: <20070901205457.GK9260@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Sep 01, 2007 at 01:37:18PM -0400, Constantine A. Murenin wrote:
>   
>> On 01/09/07, Jeff Garzik <jeff@garzik.org> wrote:
>>     
>>> Constantine A. Murenin wrote:
>>>       
>>>> This will hopefully help diminish certain myths about the code licensing.
>>>>         
>>> What myth?  The myth that Theo understands dual licensing?
>>>       
>> Reyk's code was never dual licensed, so it's not like it even matters
>> to the original dispute.
>>     
>
> It's no longer dual licenced in the FreeBSD tree because the FreeBSD 
> people removed the GPL choice of the dual licenced code 3 months ago.
>
> So all of Theo's accusations of people breaking the law by making this 
> dual licenced code GPL-only apply as well to the FreeBSD people...
>   

Sigh, why actually check the facts when you can make them up.   The code 
in question is my code.  It has my copyright (modulo bits shared with 
onoe-san who was consulted on the switch from dual-bsd/gpl to bsd only 
in freebsd).  Of course what was amusing was how after I changed the 
license on the current code in freebsd certain folks retroactively 
applied the license changes to code that was 3 years old.

But is there a point to all this nonsense?  I dual-licensed the code so 
folks could adopt and use it however they saw fit.  As I've said before 
I don't care what people do with the work I give away so long as they 
don't claim it's their own.

>   
>> That said, I don't see what exact wording you consider inaccurate.
>>     
>
> Both the FreeBSD and Linux people draw the logical conclusion that this 
> "Alternatively" means everyone can always choose to remove one of the 
> two choices alternatively offered.
>
> According to Theo, that is "breaking the law"...
>
>   

I've yet to see "FreeBSD people" speak up so again you're just spouting 
jibberish.  I am speaking up as the author of the code that set the dual 
license in place.  I have the definitive say and I have said that any of 
my code that is dual-licensed can be made gpl only.

    Sam

