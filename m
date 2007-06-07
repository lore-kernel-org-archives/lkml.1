Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXFGQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXFGQGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXFGQGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:06:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:45126 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFGQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B+PSekpNG7ZhBurCjYbJeUdeAWjzJmYqU6Y8WXjSAHaoCnKZhz6j9N7OMQs3K59yDhWws6uYzc+rCm9IyF64FIkmF+oMD23WJvGnc6YCrCZYftp4exrd5Yk2KtaiPCMquOs3CRz/97J0IngcThyaWyKBbCSeIcNpWiO/GfugAR4=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Linux 2.6.22-rc4
Date: Thu, 7 Jun 2007 12:06:05 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org> <200706071124.30128.gene.heskett@gmail.com> <Pine.LNX.4.64.0706071738240.13101@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706071738240.13101@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071206.06298.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007, Jan Engelhardt wrote:
>On Jun 7 2007 11:24, Gene Heskett wrote:
>>>>> It is too stable for me.
>>>>
>>>>I wish all our testers were you ;)
>>>
>>>It [2.6.22-rc4] did not die on me so far, unlike that stock FC7 kernel
>>>(same config but without fc patches).
>>
>>Oh its stable allright, but why do I have to turn the monitor off by hand
>> when I leave.  None of that is working, not even the screen blanker.
>
>VC or X?
>
>
>	Jan

Regular X, fc6 box, amd xp2800.  Using NVIDIA's latest driver, and it works 
when booted to a 2.6.21 era kernel.

Just about up to date, seems I have to do the kde stuffs one or two pieces at 
a time as yumex isn't handling the deps well otherwise.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The inherent vice of capitalism is the unequal sharing of blessings;
the inherent virtue of socialism is the equal sharing of misery.
		-- Churchill
