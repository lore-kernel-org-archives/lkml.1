Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZF3Fat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZF3Fat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZF3Faj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:30:39 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:52843 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZF3Fai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s10w3o/HeY27B3Zf3BmmtxhanGvWOXVzXyILHsgPcBiN0Q10wvKLD1FUC5FOIjT4wI
         QrE/njkbhQL1rZ1n30+HyLcK7KHFJkR52q/OiyBgJ25YdnXivAArX+2b+tyhbuyjb/X1
         T5WrdtncICT+TPscOxXGugwKzziqtx/O2TzLA=
MIME-Version: 1.0
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1A06@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C3@SJEXCHCCR02.corp.ad.broadcom.com>
	 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com>
	 <20090627053317.GG8587@game.jcrosoft.org>
	 <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1A06@SJEXCHCCR02.corp.ad.broadcom.com>
Date: Tue, 30 Jun 2009 11:00:41 +0530
Message-ID: <5d5443650906292230k27e70863l49566462328f0a43@mail.gmail.com>
Subject: Re: [PATCH v1 3/6][ARM] new ARM SoC support: BCMRing
From: Trilok Soni <soni.trilok@gmail.com>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leo,

>>
>> On 16:29 Fri 26 Jun     , Leo (Hao) Chen wrote:
>> > Hi,
>> >
>> > This is the third patch.  This big patch contains the core
>> arch code in arch/arm/mach-bcmring directory.
>> > Header files in arch/arm/mach-bcmring/include/mach are
>> included as well.
>> You need to check your patches with checkpatch.pl as your
>> patches do not respect
>> the linux conding style in a lot's of space
>>
> I'll fix the errors found by the checkpatch.pl script.  Is it okay to pass the checkpatch.pl with some warnings?
>

I don't think so, but if you find any false positives you can report to ML.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
