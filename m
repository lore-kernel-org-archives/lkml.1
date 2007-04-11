Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXDKKQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXDKKQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXDKKQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:16:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:49260 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXDKKQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RUPZqp1Q+uTy5Az981uS1Qro/o3EfBZitguk0nI7nyOGGjIz7SwPS2VGmyuiTg+TR3FNVaEw4AFLY3AQ/ZX/Tx9JwggGiQyLXASsXK7mqDw8ynZEjA1Rs6QhQmeK9F/vWDIvxmAvafRFxL1/+E341zGRtQobZvCXvIPWg0XFcf0=
Message-ID: <461CB584.1050309@gmail.com>
Date: Wed, 11 Apr 2007 19:16:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Conke Hu <conke.hu@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ahci.c: remove non-existing SB600 raid id
References: <5767b9100704110254s16566ce7n147aa578181d84e6@mail.gmail.com>	 <461CB1B1.9030207@gmail.com> <5767b9100704110312t3ce53bd6u1dbb50c79eeb8d7@mail.gmail.com>
In-Reply-To: <5767b9100704110312t3ce53bd6u1dbb50c79eeb8d7@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Conke Hu wrote:
> On 4/11/07, Tejun Heo <htejun@gmail.com> wrote:
>> Conke Hu wrote:
>> >    SB600 RAID and SB600 SATA is the same controller and share the
>> > same PCI ID 0x4380. There is such PCI ID 0x4381.
>>
>> I assume 'no' is missing in the last sentence.  :-)
>>
>> -- 
>> tejun
>>
> 
> Oh, sorry :(
> so, should I re-send the mail?

It isn't my call but I think it's okay.  I just couldn't resist the
bait.  :-)

-- 
tejun
