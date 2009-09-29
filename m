Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZI2VT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZI2VT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZI2VT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:19:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:51960 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZI2VTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mf5y5jwmy0QzfBhXnmpW0h2s1+fmMFsQPRFQHWjtkVDkg4ofS5jU+jnMDUg3QDkIrh
         /tDS5v1iMHsLS3RrYT1cnem/bprVVrkvqidJvUz25t3126U5qUNwzZ1W/zerbI3NWuZ+
         ozTvw9wW+KAKH/8amSxaS70jVTwdBUfUzaDfc=
MIME-Version: 1.0
In-Reply-To: <20090929141450.b2b36e4d.akpm@linux-foundation.org>
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org> 
	<1253682664-27040-1-git-send-email-vapier@gentoo.org> <8bd0f97a0909291404v6d7f8a9dyb19fa8ad48f9484f@mail.gmail.com> 
	<20090929141450.b2b36e4d.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Sep 2009 17:19:09 -0400
Message-ID: <8bd0f97a0909291419m7e069652s5b6b2b3f14d44ba6@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction LCD 
	Backlight and Keypad Input Device Driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sameo@linux.intel.com, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 17:14, Andrew Morton wrote:
> On Tue, 29 Sep 2009 17:04:21 -0400 Mike Frysinger wrote:
>> On Wed, Sep 23, 2009 at 01:11, Mike Frysinger wrote:
>> > From: Michael Hennerich <michael.hennerich@analog.com>
>> >
>> > Base driver for Analog Devices ADP5520/ADP5501 MFD PMICs
>>
>> could you check this out/pick up Andrew ?
>
> Spose so.  Is Samuel not around?

all the other MFD patches were noticed/reviewed/picked up

> Does this patch have any dependencies on other stuff we weren't told about?

the other way around.  this is the core.
-mike
