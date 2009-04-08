Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbZDHJ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbZDHJ1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZDHJ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:27:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZDHJ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BEHXTeSM2F1Ix1EDSgzIDmrCjIF216dDktSrkmyRL8bnxd2gciUv7B0LMRi2I/Jp8Q
         Z8qhLgtf6Ln3tl3uGPm6ELa3m3M0YEKVwIDcIQHm/8RAAlY3GyXSOWCLHp3cb/EkmGtQ
         03PPD4JXLwZbf++JAv1MBVlcaDWtvsotTjyao=
MIME-Version: 1.0
In-Reply-To: <8db1092f0904070049o675de150qd319fc5853ec9bd8@mail.gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.bxC.BJn2JB@chimera> <1239088491.19390.25.camel@violet>
	 <8db1092f0904070049o675de150qd319fc5853ec9bd8@mail.gmail.com>
Date: Wed, 8 Apr 2009 11:27:35 +0200
Message-ID: <8db1092f0904080227h15cfc1fdm762f1e0a4e077786@mail.gmail.com>
Subject: Re: [Bug #12499] Problem with using bluetooth adaper connected to usb 
	port
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 2009/4/7 Marcel Holtmann <marcel@holtmann.org>:

[...]

>> I prefer to have this checked against 2.6.30-rc1 once Linus released
>> that one. I think that I know the root cause for this one and it is
>> actually a hardware/firmware bug. Some Bluetooth dongles expect to have
>> the interrupt and bulk URBs available at the same time. Otherwise they
>> do pee in their pants.
>
> I will check -rc1 when will be available.
>

2.6.30-rc1 works. Thanks

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
