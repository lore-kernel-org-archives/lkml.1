Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYKGO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYKGO5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYKGO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:57:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:37306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYKGO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:57:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k98v2fAi+PgVBDw1jQJ6YgxayEcR0G4787XCiiX11WzecWn9Y3xVKuMSw65oYQngCi
         6U9ZmTeIv2kr5yhjOGajDCg9q+pu5+Rfwf0yoGlqKmy5UqP/NoLXzADkoXHbGCp/GuLI
         ylDVQSNBkmol/gbK1jGu7H7vLx6NhNXMHU2T4=
Message-ID: <bc64b4640811070657p668dcaedrfd442b0d439b3c78@mail.gmail.com>
Date: Fri, 7 Nov 2008 17:57:33 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Cyril Hrubis" <metan@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com
In-Reply-To: <20081107142923.GA1616@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz>
	 <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
	 <20081105173303.GC2038@elf.ucw.cz>
	 <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com>
	 <20081106080416.GA1531@ucw.cz>
	 <20081106191424.GA2273@atrey.karlin.mff.cuni.cz>
	 <f17812d70811070523k59a57d49tac1ab1e5b78d1db4@mail.gmail.com>
	 <20081107142923.GA1616@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/7 Pavel Machek <pavel@suse.cz>:
> On Fri 2008-11-07 21:23:41, Eric Miao wrote:
>> Well, IIRC spitz still needs the patch to change the vmlinux.ld.S.
>> Did you guys ever try that?
>
> I never heard about that patch, do you have it handy?

http://rpsys.net/openzaurus/patches/archive/pxa-linking-bug.patch

I plan to submit a bit modified version of this patch later.

>
>                                                                Pavel
>
>> On Fri, Nov 7, 2008 at 3:14 AM, Cyril Hrubis <metan@ucw.cz> wrote:
>> > Hi,
>> >> I do not have serial cable :-(,
>> >
>> > Okay I have one that works for sl5500, it needs external power on
>> > sl-cxxx but it should be easy to fix.
>> >
>> > --
>> > metan
>> >
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
With best wishes
Dmitry
