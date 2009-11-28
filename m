Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbZK1Omu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbZK1Omu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 09:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZK1Omu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 09:42:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:21267 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZK1Oms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 09:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cIFcx1FVgzjuiwUmKxa12HIRWHV1hTRHtYgw0Kn97XKWwgzqRgsB8FKQrEYO/5BuaE
         nLkv1Z+iFcLiJCxSXi7K6PaecOWHP1aFsztp5tjiMY3vPJf3BC7xDNhTlD9MpFp0YaVH
         I42Evn2ELOk9/jIIz2Xrg6igMoog2RRbBkDV4=
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jon Smirl <jonsmirl@gmail.com>,
       Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
       awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
       jarod@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <m37hta28w9.fsf@intrepid.localdomain>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 16:42:48 +0200
Message-ID: <1259419368.18747.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-28 at 12:20 +0100, Krzysztof Halasa wrote: 
> Maxim Levitsky <maximlevitsky@gmail.com> writes:
> 
> > If we add in-kernel decoding, we still will end up with two different
> > decoding, one in kernel and one in lirc.
> 
> And that's good. Especially for a popular and simple protocol such as
> RC5.
> Actually, it's not about adding the decoder. It's about fixing it.
> I can fix it.

This is nonsense.



