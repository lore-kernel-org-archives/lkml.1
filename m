Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZJKO6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZJKO6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZJKO6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:58:03 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52597 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZJKO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p+B2n20+SIg6zif1MzOCPQfvRtOI40D1i0v6BkvyXJs9kaidhZFb9L0hGe7rxsUATr
         q+qMdxJTWTYZR7CRGNivmhz8PclFWzaEGs746ZRqhdOEdYe8uWvfN1kNjRbS+jjygIhU
         VD9HnrOsEJ2D+3rCRG6w6xDKimREG2O5aTCuc=
MIME-Version: 1.0
In-Reply-To: <20091011141638.616084c0@lxorguk.ukuu.org.uk>
References: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com>
	 <20091011141638.616084c0@lxorguk.ukuu.org.uk>
Date: Sun, 11 Oct 2009 16:57:25 +0200
Message-ID: <71cd59b00910110757w7c0e21d4h7ed2f9f37228f3da@mail.gmail.com>
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

Great :(
I think I'll try to find another controller card/motherboard...

-- 
Corentin Chary
http://xf.iksaif.net
