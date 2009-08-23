Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbZHWTEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbZHWTEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 15:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933613AbZHWTEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 15:04:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:22393 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbZHWTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eT9PnDNSIPhkoPJafo2v1rrloZYmypjXJM33uO+H+P1y5ZhtLYL95ignCtxE9eXTIE
         TWX1btvAhK6aPZTT2x+ydO9ONd4uTce7M/3BCxs2zucZ37DQt8qnB+990P3nJAtHIg/w
         3aaFrTIvnhWNE8lCOK6KQ5sVFE5xi9yYgOo+M=
Message-ID: <4A9192C5.2090304@gmail.com>
Date: Sun, 23 Aug 2009 21:04:37 +0200
From: Xavier Gnata <xavier.gnata@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Nigel Cunningham <ncunningham@crca.org.au>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TuxOnIce-devel] What to do?
References: <4A8CCF95.9030401@crca.org.au> <200908201724.34430.rjw@sisk.pl>
In-Reply-To: <200908201724.34430.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 20 August 2009, Nigel Cunningham wrote:
>   
>> Hi all.
>>     
>
> Hi,
>
>   
>> A few months back, I posted TuxOnIce for something like the third time,
>> seeking to see if we could make some progress on getting it merged. The
>> outcome of that was an agreement between Rafael and I that we'd work on
>> getting TuxOnIce functionality (if not the actual code) merged bit by
>> bit, improving swsusp rather than doing an outright merge.
>>
>> Unfortunately, as the intervening months have shown, Rafael is busy with
>> other things and so am I. The few patches I did prepare and post have
>> had no review, and I haven't had a chance to build on or rework them
>> since. (I'd actually like them not to be merged, because I've realised
>> that there are more foundational changes that need to go in first.)
>>
>> Given that this has been the outcome so far, I see no reason to imagine
>> that we're going to make any serious progress any time soon.
>>     
>
> That unfortunately is probably right.
>
> The problem for my part is that new things are still appearing that I need to
> take care of rather urgently.
>
> In fact the user space part of (u)swsusp also has been suffering from the lack
> of attention recently, so to speak.
>
>   
>> I'd therefore like to ask whether there's anyone out there who could do
>> one or more of:
>>
>> 1) Step up to the plate and help improve swsusp, without relying on any
>> help from me but with my blessing if they choose to copy wholesale bits
>> of TuxOnIce;
>> 2) Take over maintaining TuxOnIce from me;
>> 3) Some other way forward that hasn't occurred to me.
>>
>> Thoughts, input, flames, whatever else welcome. A lack of deadly silence
>> would be especially appreciated :)
>>     
>
> Well, the code is out there.  If there's time to try to get it in, I think it's
> worth doing.
>
> Best,
> Rafael
>   

Well I have no time to jump into the details of the code but I can test 
whatever you want :)

Xavier
