Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbZFJM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbZFJM1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbZFJM1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:27:14 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56309 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbZFJM1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mn8eiRqrBfAtKpD3uod5BrV+GNjK0k2xh+7hy/b5/UAAtKXCCXIJK7HjHVxbNmaMvY
         DxRckE9O0osxBM3C96lR8L0l+QxAKUFL2GmjXosIKYn2Ma4ZgirZ294qtLtjFeYRvujI
         +uZ29VB9ruGdMbgBy+MxWScRvgzIa81SUOR2g=
MIME-Version: 1.0
In-Reply-To: <200906021611.35649.rgetz@blackfin.uclinux.org>
References: <200906011526.01108.rgetz@blackfin.uclinux.org>
	 <200906011657.20251.rgetz@blackfin.uclinux.org>
	 <20090602130720.GA6259@mx.loc>
	 <200906021611.35649.rgetz@blackfin.uclinux.org>
Date: Wed, 10 Jun 2009 14:27:14 +0200
Message-ID: <1158166a0906100527k5ca5d538i9c441934ed8db238@mail.gmail.com>
Subject: Re: [PATCH] update kernel's scripts/bloat-o-meter from busybox
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>,
       Matt Mackall <mpm@selenic.com>, Sam Ravnborg <sam@ravnborg.org>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 10:11 PM, Robin Getz<rgetz@blackfin.uclinux.org> wrote:
> On Tue 2 Jun 2009 09:07, Bernhard Reutner-Fischer pondered:
>> Fine with me either way, sure. All parts i ever touched in bloat-o-meter
>> (and kbuild, kconfig) are:
>> Signed-off-by: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
>
> On Tue 2 Jun 2009 01:59, Rob Landley pondered:
>>
>> Nah, the patches I sent got applied, I just haven't messed with it in
>> the past couple years.  So you don't need my signed-off-by, but I'm happy
>> to give you an:
>>
>> Acked-by: Rob Landley <rob@landley.net>
>
> So - that is Bernhard & Rob --
>
> Denis you there?

No internet at home at the moment. Sorry for the delay.

> Sam/Matt - assuming that Denis sends his

Sure,

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

--
vda
