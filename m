Return-Path: <linux-kernel-owner+w=401wt.eu-S376211AbXECQgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376211AbXECQgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376224AbXECQgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:36:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:55063 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376211AbXECQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AvDCN5J1hYoKinhIDhjiOECSltAAJrOxc4qfdmyBt6uwkBwwrMoQzcVQaYyxdFJ3eSN9zUxFssu8iXiGtdJGI6OAiDdK9NvAw+wVrAh3RpJ05QlTgMiFKpf4kwEJlofw+ez0Jym79SLT8hX4WUsZAf9da1aWiv6z2LWpfvf50Rk=
Message-ID: <463A0F59.8070900@gmail.com>
Date: Thu, 03 May 2007 20:35:37 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Uwe Bugla <uwe.bugla@gmx.de>, xyzzy@speakeasy.org, mrechberger@gmail.com,
       mchehab@infradead.org, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<4636E0E2.5020601@simon.arlott.org.uk>	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net> <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net> <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net> <463A0462.5070106@gmail.com> <20070503160514.184710@gmx.net> <463A0AB7.5030704@gmail.com> <463A0E1B.2010509@linuxtv.org>
In-Reply-To: <463A0E1B.2010509@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> Manu Abraham wrote:
>> Uwe Bugla wrote:
>>   
>>> If you download the thing as tar.bz2 you get a zero file down.
>>>     
>> I think could be a bug in hgweb probably.
> [snip]
>> Let me see why hgweb gives a zero length archive
>>   
> Manu,
> 
> We reported this bug to the selenic guys quite a long time ago...   You
> should inherit the fix if you upgrade mercurial on your server.
> 

Cool. Thanks.

I think it is a newer version ..

[manu@bh ~]$ hg --version
Mercurial Distributed SCM (version 0.9)

Copyright (C) 2005 Matt Mackall <mpm@selenic.com>
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

You have an account on that machine. Would you like to take a look ?

