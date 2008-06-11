Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYFKDz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYFKDz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYFKDzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:55:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:23474 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbYFKDzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GAAgKMFxKDiOjaw8PXjOycekacoi//6zuju5/aIt+xKu6KXaJA3bSLyPRcpqszg1Gx
         hxeeeOtU8kIPCTTVJgoif33Kj8HA16ax2Wy/KWhKwn0giV+8kY9/ZFGgv9bV6PFJy69v
         GVRzSv2xhx48V6aifE5D6+fQuzKEWwGYOw+0c=
Message-ID: <386072610806102055i5c119e74hfedf37cb6a7e57fb@mail.gmail.com>
Date: Wed, 11 Jun 2008 11:55:01 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: blackfin drivers/net/smc91x.c build error
Cc: "Adrian Bunk" <bunk@kernel.org>, "Mike Frysinger" <vapier.adi@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806102046450.3101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162212.GC2201@cs181133002.pp.htv.fi>
	 <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
	 <20080610135349.GA30792@cs181133002.pp.htv.fi>
	 <8bd0f97a0806101013w42b9028j5dfa38d654f3d05f@mail.gmail.com>
	 <20080610173450.GC11685@cs181133002.pp.htv.fi>
	 <386072610806102037u39ec18e6ye26ef184d6a9516e@mail.gmail.com>
	 <alpine.LFD.1.10.0806102046450.3101@woody.linux-foundation.org>
X-Google-Sender-Auth: bedaab7e2604145d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 11 Jun 2008, Bryan Wu wrote:
>>
>> Linus, could you please revert it?
>> 099c736a470c8080a166e7a089f1e48e15f9947c
>> Or I send a patch out to revert it?
>
> I'd like to see a patch, since by now I'm confused by this all whether
> it's a straight revert or if there's a fix.
>
>                        Linus

No problem, I will send a patch soon.

-Bryan
