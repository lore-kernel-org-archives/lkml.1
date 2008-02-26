Return-Path: <linux-kernel-owner+w=401wt.eu-S1763916AbYBZWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763916AbYBZWRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYBZWRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:17:13 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:36985 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYBZWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:17:12 -0500
Message-ID: <47C48FD8.5040205@student.ltu.se>
Date: Tue, 26 Feb 2008 23:16:56 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: khc@pm.waw.pl, bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
References: <1204062430.47c488def40a4@portal.student.luth.se> <20080226135444.f83a0536.randy.dunlap@oracle.com>
In-Reply-To: <20080226135444.f83a0536.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 26 Feb 2008 22:47:10 +0100 ricknu-0@student.ltu.se wrote:
>
>   
>> Relaxing the 'tab = 8 character', which leads to 'don't tab the alignment'.
>> By only using tabs for indentation, we solidify it as a 'logical indentation'.
>>
>> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
>> ---
>> To'ed the people who showed interest in the (apparently not so new)
>> question/suggestion of not using tabs when aligning.
>> If this looks ok, then checkpatch.pl is next...
>>
>>
>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>> index 6caa146..1b3f448 100644
>> --- a/Documentation/CodingStyle
>> +++ b/Documentation/CodingStyle
>> @@ -15,10 +15,8 @@ Anyway, here goes:
>>  
>>  	 	Chapter 1: Indentation
>>  
>> -Tabs are 8 characters, and thus indentations are also 8 characters.
>> -There are heretic movements that try to make indentations 4 (or even 2!)
>> -characters deep, and that is akin to trying to define the value of PI to
>> -be 3.
>> +This project is recommended to be viewed with a tab-width of 8 characters
>> +(and other code).
>>     
>
> FWIW I prefer the {deleted} language.  // PI = 3;
>   
Well, actually I like it too. But I think it should be up to the 
programmer which setting to use + it seems some people have really taken 
this to heart, going from 'tab => 8 characters wide' to '8 spaces => 
tab', obscuring tab's position as a 'logical indention'.

Richard Knutsson

