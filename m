Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab0CLKVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:21:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51594 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab0CLKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kR58Br6qtP54zexRlfYgrWHr6/zkh/zguisqxboAVcbn3H77Ny8zeM3aEqnIMO9Czg
         aixAOkhDEmQ/NIW/yQC1w5ZUmzop4aPWIvprahv/Eyg57X+mKIUsH+50Dh10fS+GbtXx
         W5GjOUnaBzpoYETJMzed8QO4ekL0NV3dOySMM=
MIME-Version: 1.0
In-Reply-To: <tnx8w9xn94k.fsf@e102109-lin.cambridge.arm.com>
References: <40a4ed591003110534k1ab9c343r35ac45f64476bdc6@mail.gmail.com>
	 <tnx8w9xn94k.fsf@e102109-lin.cambridge.arm.com>
Date: Fri, 12 Mar 2010 11:21:22 +0100
Message-ID: <40a4ed591003120221s24d9342cp20eded26f44fc90e@mail.gmail.com>
Subject: Re: kmemleak: 17 new suspected memory leaks
From: Zeno Davatz <zdavatz@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 11:10 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Zeno Davatz <zdavatz@gmail.com> wrote:
>> This may or may not be connected to the ata-timeout issue but it is in
>> the same place in my dmesg:
>>
>> kmemleak: 17 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>>
>> See attached file for all of the 17 issues.
>>
>> Let me know if you need any other information.
>
> Kernel version?

uname -a

Linux zenogentoo 2.6.34-rc1 #79 SMP Tue Mar 9 16:48:13 CET 2010 i686
Intel(R) Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux

Best
Zeno
