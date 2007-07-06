Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbXGFHvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbXGFHvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXGFHv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:51:29 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:56992 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbXGFHv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:51:28 -0400
Message-ID: <468DF478.1080403@l4x.org>
Date: Fri, 06 Jul 2007 09:51:20 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070628)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: bryan.wu@analog.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Blackfin arch fixes (try #2)
References: <1183423041.10353.8.camel@roc-laptop> <468A560A.9050801@l4x.org>	 <8bd0f97a0707031055h7b97c0cerbd2314a2836f7798@mail.gmail.com>	 <468C053D.9050302@l4x.org> <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
In-Reply-To: <8bd0f97a0707060022x16732628ofc3c0a6004776cbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 7/4/07, Jan Dittmer <jdi@l4x.org> wrote:
>> Mike Frysinger wrote:
>> > On 7/3/07, Jan Dittmer <jdi@l4x.org> wrote:
>> >> Bryan Wu wrote:
>> >>> Jie's patch is required because we will release our new Blackfin 
>> toolchain.
>> >> So, what is the new toolchain version?
>> >> gcc 4.1.1 (adi 07r1) / binutils 2.17 doesn't seem to work anymore:
>> >
>> > we'll post new toolchain binaries in a bit
>>
>> Hrm, somehow I don't understand it. On [1] you're
>> talking about gcc 4.1.2 and binutils 2.17 supporting
>> the -mcpu switch. But if you download the 2007R1 RC9
>> toolchain from the Files section of the site (tar.gz)
>> you actually get 4.1.1 without mcpu support. But the
>> version string from gcc indicates 07r1.
>> Care to explain?
> 
> the syntax of the -mcpu option was extended

But the tar-ball does _not_ contain 4.1.2

Jan
