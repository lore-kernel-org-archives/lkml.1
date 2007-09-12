Return-Path: <linux-kernel-owner+w=401wt.eu-S971145AbXILRjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971145AbXILRjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765656AbXILRjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:39:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6217 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765647AbXILRjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FFtgwGQXEtDzRAdBdZZDrsqdnN55pJvbMBl8uZ6wuqS95lMdorM9+M5Cm8fNuvaWOyB2BLKFfwYZU+Czcb5PQeMaBia2F1J1cMi65xg6LO4T0wvL1C/4/A2AwLezS3GJhIpT62afIXZNP4vh3y8afBtyG0AR8N+ZPV4yk4XttZI=
Message-ID: <46E82417.8020501@googlemail.com>
Date: Wed, 12 Sep 2007 19:38:31 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-alpha@vger.kernel.org,
       Stefan Becker <Stefan.Becker@nokia.com>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Jakub Jelinek <jakub@redhat.com>,
       Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       "Adrian Bunk \"\"" <bunk@kernel.org>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
References: <46E81AC6.3000306@googlemail.com> <1189617555.4513.3.camel@chaos>
In-Reply-To: <1189617555.4513.3.camel@chaos>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner pisze:
> On Wed, 2007-09-12 at 18:58 +0200, Michal Piotrowski wrote: 
>> Subject         : x86_64 vdso patch is broken somehow?
>> References      : http://lkml.org/lkml/2007/8/29/136
>> Last known good : ?
>> Submitter       : Chuck Ebbert <cebbert@redhat.com>
>> Caused-By       : Andi Kleen <ak@suse.de>
>>                   commit 2aae950b21e4bc789d1fc6668faf67e8748300b7
>> Handled-By      : ?
>> Status          : unknown
> 
> Patch available:
> http://lkml.org/lkml/2007/9/11/161

It is already fixed ;)

> 
>> Subject         : cpu hotplug support broken in 2.6.23-rc3/highres timers break cpu hotplug in 2.6.23-rc5
>> References      : http://lkml.org/lkml/2007/8/27/58
>>                   http://lkml.org/lkml/2007/9/3/65
>> Last known good : ?
>> Submitter       : Pavel Machek <pavel@ucw.cz>
>> Caused-By       : ?
>> Handled-By      : ?
>> Status          : problem is being debugged
> 
> This might be the same problem as the jinxed VAIO suspend/resume thingy,
> which is a regression as well.
> 
> Please assign the Handled-By to me.

Ok.

> 
> Thanks,
> 
> 	tglx
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
