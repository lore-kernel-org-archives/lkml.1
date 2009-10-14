Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZJNS13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZJNS13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbZJNS12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:27:28 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54276 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbZJNS11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FP9gewaRxjXI3KntKKo8/PF7Ji6w9TJXYdO002XsGv4JXcpR3Ej2ZaTxCGR/alKkd6
         aKL2htiQXTdDu2mUdYP2yK2Up3BM+wTkmNILYa8YTZjElq6mBCZgHQV+XMhL1mTtmkHh
         UPJhjpv2fnBTBSB2bkFL3Hh4Rdqa78aU6Q2aQ=
MIME-Version: 1.0
In-Reply-To: <200910141933.09374.bzolnier@gmail.com>
References: <4AD46380.9020308@pardus.org.tr>
	 <200910141728.21491.bzolnier@gmail.com>
	 <20091014164710.GF2890@tuxdriver.com>
	 <200910141933.09374.bzolnier@gmail.com>
Date: Wed, 14 Oct 2009 19:26:49 +0100
Message-ID: <efe7343f0910141126o54ea2e31r5327e0db06a8b7ec@mail.gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
From: Luis Correia <luis.f.correia@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 18:33, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Wednesday 14 October 2009 18:47:11 John W. Linville wrote:
>> On Wed, Oct 14, 2009 at 05:28:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
>>
>> > I don't have a have a problem with it personally as long as people accept
>> > the competition..  but instead of working on _their_ projects they go around
>> > screaming at everybody who does not want to spin inside the great process
>> > designed by them..
>>
>> Please whine somewhere else.  You have the freedom to work in
>> drivers/staging all you want.  You do not have the power to force us to
>> like it -- especially in a case where you are diverting attention from
>> the community-maintained drivers instead of cooperating with them.
>
> Cooperating you say.
>
> rtl8187 -- before starting the work on rtl8187se I've pinged the maintainer
> to coordinate the effort and hear his opinion on how to progress..
>
> I've never heard back.
>
> rt2x00 -- I know that people have datasheets for some chipsets but I've
> never heard "How can we help you" etc. thing.

I have all the datasheets that Ralink supplied to us.
All of them are PRELIMINARY and most have errors, and therefore useless.

All useful information is in the crap drivers.

Ralink never provide better ones, and even our 'inside guy' says the
hardware documentation guys are always very late in providing more
info.

So, for me, it isn't lack of documentation that will ever help, believe me.

>
> All I've ever heard was _lies_ about current state of affairs or that
> my work is in the way.

AFAICS, your work was never questioned, at least by me.
You are welcome to work on rt2x00 , that was also never a problem. All
you would need is join in.

Ralink also said they were commited to present drivers for new chipset
to be mac80211 compliant, we're waiting on that.

So, you're really welcome to join the rt2x00 team Bartlomiej, the only
thing we ask is that all work should be done using the existing
rt2x00lib, rt2x00pci and rt2x00usb base 'libraries'.

Luis Correia,
rt2x00 project admin
