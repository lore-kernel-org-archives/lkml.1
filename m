Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZJNH1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZJNH1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZJNH1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:27:10 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59986 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZJNH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nRJd5EozH0E8zQQ/4QOk6A8FY7ny2vYbvydZwZcS+N6cJ38Bx+776V9mH2fRqKRyYB
         4S32sQk6OSnGo+D82MNAXJS77Xqv7gsn1yTPykGJdXDOeLs/zAxfCLJ2LY2fK5undy6h
         dmQ0bekZTZ6zNVHUbg/xYAdyGKKimZPLu8i3E=
MIME-Version: 1.0
In-Reply-To: <20091011141638.616084c0@lxorguk.ukuu.org.uk>
References: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com>
	 <20091011141638.616084c0@lxorguk.ukuu.org.uk>
Date: Wed, 14 Oct 2009 09:26:32 +0200
Message-ID: <71cd59b00910140026w3aeab5f0q4913294fe77d9dc0@mail.gmail.com>
Subject: Re: VT6421 problems with sata_via
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 3:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 11 Oct 2009 11:54:49 +0200
> Corentin Chary <corentin.chary@gmail.com> wrote:
>
>> Hi,
>> I recently needed some more space and bought a Deskstar 7K1000.B for my server.
>> The motherboard is old, and did not have SATA port, so I added a
>> VT6421 PCI SATA controller.
>
> Lots of 6421 setups do not work on Linux full stop. I've asked VIA
> several times for the relevant data sheet/info to fix this and they've
> never done more than acknowledge receipt of the mail.
>
> Alan
>

I tried to contact VIA, they said the datasheet have been available
for some month,
here is the link they gave to me:
ftp://vtbridge.org/Docs/Storage/DS_VT6421A_100_CCPL.PDF
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
