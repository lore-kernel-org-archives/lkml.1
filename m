Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYIPOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYIPOda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYIPOdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:33:22 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:47076 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYIPOdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i8iLovrYryGHcm7gckqPTmbJc55c8CGNimvf2byY5E6bMVov2kmEyh8uUS6HFTmw2w
         XuVMN/aXcFkxio+jK0KZmS9gfDHhCHlYJw2Aage03UjMBd6tVWRmYpxx8GJGCXGsmV+x
         4/Q3EPncER6bEuYBu9UwrNLe96eE9TJgv2A5w=
Message-ID: <ab40e9c0809160733k5ba2e009h9ff2bca3e530d48@mail.gmail.com>
Date: Tue, 16 Sep 2008 16:33:20 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: looking for a function
Cc: "Bernd Petrovitsch" <bernd@firmix.at>, linux-kernel@vger.kernel.org
In-Reply-To: <c62985530809160729m261207ben15b6c05440703451@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
	 <1221573632.6103.83.camel@spike.firmix.at>
	 <ab40e9c0809160711p4182d9e7n9b3ce965b3ce9f1f@mail.gmail.com>
	 <c62985530809160729m261207ben15b6c05440703451@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

thank you very much!
this is very useful for me. :-)

Best regards,

Yang

2008/9/16, Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/9/16 Xu Yang <risingsunxy@googlemail.com>:
> > Hi Bernd,
> >
> > thanks for you reply.
> >
> > yes, I know the thread migrates all the time, this is exactly what I
> > would like to observe. I would like to learn about the thread
> > migration of some specific scheduling algorithm. so ....
> >
> > any idea about the function?
> >
>
> And perhaps you should have a look at the sched_switch tracer which
> will log for you the different context switches.
>
> Regards,
>
> Frederic.
>
