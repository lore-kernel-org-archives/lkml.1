Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbXCXSTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbXCXSTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 14:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXCXSTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 14:19:33 -0400
Received: from www17.your-server.de ([213.133.104.17]:2899 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXCXSTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 14:19:32 -0400
Message-ID: <46056BF3.3070707@m3y3r.de>
Date: Sat, 24 Mar 2007 19:20:35 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de> <m1slbu4j0p.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slbu4j0p.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> Thomas Meyer <thomas@m3y3r.de> writes:
>
>   
>> Adrian Bunk schrieb:
>>     
>>> Subject    : second suspend to disk in a row results in an oops  (libata?)
>>> References : http://lkml.org/lkml/2007/3/17/43
>>> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>>> Status     : unknown
>>>   
>>>       
>> The problem is identified: http://lkml.org/lkml/2007/3/22/150
>>     
>
> Given the description above I'm a little confused.  Doesn't this
> happen every time now?
>   
With current git head the oops happens in the second suspend to disk
attempt in a row.
> Or was this happening only the second time before I started my msi
> fixes... 
>   
So i think, that the current git head already contains your msi fixes.
I don't know if this already happend before your msi changes, but i can
test 2.6.20 if you like to?

