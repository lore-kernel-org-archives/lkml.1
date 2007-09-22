Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXIVEVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXIVEVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 00:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbXIVEVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 00:21:25 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49264 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXIVEVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 00:21:24 -0400
Message-ID: <46F497F0.1090608@gmail.com>
Date: Sat, 22 Sep 2007 06:20:00 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH -mm] sb16: Shut up uninitialized var build warning
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in> <46DB33D0.40204@gmail.com> <200709201852.11497.vda.linux@googlemail.com>
In-Reply-To: <200709201852.11497.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 07:52 PM, Denys Vlasenko wrote:

> On Sunday 02 September 2007 23:06, Rene Herman wrote:

>> Blah. Your message has:
>>
>> 	Content-Type: TEXT/PLAIN; charset=iso-2022-jp
>>
>> This apparently is caused by a combination of GCC using groovy UTF tickmarks 
>> in its error messages when in a UTF locale and alpine believing it to be a 
>> great idea to automatically try for the "simplest" character set it can 
>> encode the content in. No idea why that means that iso-2022-jp is picked, 
>> but it is.
>>
>> While I could actually read the message this time you should see what 
>> iso-2022-jp does to my font. It's scary. Best solution as far as I'm 
>> concerned is slap a few GCC developers (not that it wil help, but it'll 
>> certainly feel good) and then teach alpine to go for UTF-8 directly if 
>> US-ASCII won't do.
> 
> rotfl.
> 
> Kindly give me permission to convert your email into gcc bugreport
> and/or to forward it to gcc mailing list.

Blessings be upon thou, oh courageous one...

Rene.

