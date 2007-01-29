Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXA2AIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXA2AIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXA2AIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:08:37 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:41055 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbXA2AIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:08:36 -0500
Message-ID: <45BD3AF7.4070902@student.ltu.se>
Date: Mon, 29 Jan 2007 01:08:23 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [SCRIPT] Remove "space damage" from patches
References: <45BD177D.6060907@student.ltu.se> <slrnerqapg.f71.olecom@flower.upol.cz>
In-Reply-To: <slrnerqapg.f71.olecom@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
>> From: Richard Knutsson
>> Newsgroups: gmane.linux.kernel
>> Subject: [SCRIPT] Remove "space damage" from patches
>> Date: Sun, 28 Jan 2007 22:37:01 +0100
>>     
>
>   
>> Hello Andrew and all
>>     
>
> Hallo.
>
>   
>> I recently tried "git-apply" on the 2.6.20-rc6-mm1 patch and found it to complain about white-spaces.
>> So as a mean to (hopefully) cut down on these nasty white-spaces (and sometimes tabs) I wrote this
>> little script. All it does is checking (lines that are going to be added) for spaces before tabs
>> and trailing spaces/tabs. I tried it on 2.6.20-rc6-mm1 and it seem to work well
>>
>> If there is someone interested, _please_ take it. Any suggestion are welcomed :)
>>
>> Richard Knutsson
>>     
>
> Nack, big and fat. It's userspace problem.
>
> If our "developers" can't use or update their every-day-tools, it's a
> shame. And this is not trolling: i'm using Jed and GNU Emacs, both are
> ok with whitespace "production".
Oh, I hope I didn't give the impression I wanted it in the kernel (that 
is why i labeled it as SCRIPT and not PATCH), as you said it is a 
userspace problem. I just thought a simple script to remove those 
whitespace could help in an imperfect world. I prefer kate since then 
you can see where the tabs begins (and other features).

Richard Knutsson

