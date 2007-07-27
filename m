Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbXG0A2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbXG0A2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXG0A2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:28:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51928 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbXG0A2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:28:31 -0400
Message-ID: <46A93CED.9090002@oracle.com>
Date: Thu, 26 Jul 2007 17:31:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: use relevant mailing lists
References: <20070726170857.dbb42674.randy.dunlap@oracle.com> <9a8748490707261717i247e7cbcgbf01ee9c69d21e3@mail.gmail.com>
In-Reply-To: <9a8748490707261717i247e7cbcgbf01ee9c69d21e3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 27/07/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Add text on using relevant mailing lists.
>>
> 
> I'd add a little bit to that - see below
> 
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  MAINTAINERS |   13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> --- linux-2623-rc1g2.orig/MAINTAINERS
>> +++ linux-2623-rc1g2/MAINTAINERS
>> @@ -23,15 +23,18 @@ trivial patch so apply some common sense
>>  4.     When you are happy with a change make it generally available for
>>         testing and await feedback.
>>
>> -5.     Make a patch available to the relevant maintainer in the list. 
>> Use
>> -       'diff -u' to make the patch easy to merge. Be prepared to get 
>> your
>> -       changes sent back with seemingly silly requests about formatting
>> -       and variable names.  These aren't as silly as they seem. One
>> -       job the maintainers (and especially Linus) do is to keep things
>> +5.     Make a patch available to the relevant maintainer(s) and mailing
>> +       list(s). Use 'diff -u' to make the patch easy to merge. Be 
>> prepared
>> +       to get your changes sent back with seemingly silly requests about
>> +       formatting and variable names.  These aren't as silly as they 
>> seem.
>> +       One job the maintainers (and especially Linus) do is to keep 
>> things
>>         looking the same. Sometimes this means that the clever hack in
>>         your driver to get around a problem actually needs to become a
>>         generalized kernel feature ready for next time.
>>
>> +       Use the relevant mailing list(s) -- don't just send everything to
>> +       lkml (linux-kernel@vger.kernel.org).
> 
> +       Always including lkml in addition to more specific lists is 
> usually OK.

Well, I'd rather not say that, but that's the type of discussion
that this patch was looking for..

>> +
>>         PLEASE check your patch with the automated style checker
>>         (scripts/checkpatch.pl) to catch trival style violations.
>>         See Documentation/CodingStyle for guidance here.

Thanks.
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
