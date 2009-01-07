Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZAGSne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZAGSne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbZAGSnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:43:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:11759 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbZAGSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:43:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jpa/+NgE7Ka3LJupDusax1HaIwMrKyH3Dz8/BPNQoId2MMesvKrId3UpVqNYrcLP/c
         Vuyz/zSVFuBF42JoxbcvIcLqOPx6aMTi0RUsG56eJWgoJn8o9h+Z2nptDxEb8AXg53q5
         30maNidt0T8MS7v0qmMa+8uRTllYiCMkwxTEo=
Message-ID: <3f9a31f40901071043u5a112962l2dd7e1d88de8aae2@mail.gmail.com>
Date: Thu, 8 Jan 2009 00:13:19 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip 0/7] x86: move NON-SMP data from smp.h
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       James.Bottomley@hansenpartnership.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090107173509.GD24982@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1231329368.17961.29.camel@jaswinder.satnam>
	 <20090107125152.GA3529@elte.hu> <20090107133327.GA4911@elte.hu>
	 <3f9a31f40901070557r336020dctbe9549e8634b167@mail.gmail.com>
	 <20090107150351.GB27606@elte.hu> <20090107151223.GA4899@elte.hu>
	 <20090107151522.GA5341@elte.hu>
	 <1231344766.3770.12.camel@jaswinder.satnam>
	 <20090107173509.GD24982@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n07IhgwM010828

On Wed, Jan 7, 2009 at 11:05 PM, Ingo Molnar <mingo@elte.hu> wrote:>> * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:>>> I send new 4 patches:>>>> ï»¿[PATCH -tip 1/4 V2] x86: smp.h move stack_processor_id declartion to cpu.h>> ï»¿[PATCH -tip 2/4 V2] x86: smp.h move safe_smp_processor_id declartion to cpu.h>> ï»¿[PATCH -tip 3/4 V2] x86: smp.h move cpu_physical_id declartion to cpu.h>> ï»¿[PATCH -tip 4/4 V2] x86: smp.h move boot_cpu_id declartion to cpu.h>>>> Please accept them.>> Just to make sure: they should solve the 3 failures i reported?>
Yes.
I am sorry for earlier errors messages.
Thanks--JSRÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
