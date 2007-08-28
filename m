Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXH1OGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXH1OGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXH1OGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:06:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:30363 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXH1OGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZmK8RTFd9m2AkOb2KNes4ynB9cxa5gdNka9AbptAgL13BZihTkCyVs62SB6xH2ewNIEJhHahKgj1jzmUm5NyPfw3YBeACraU3j5u1oHUlnYSJ6WSRHZhojlUojFf4vQKGx+3DrJTIIWWgizgQkmbdT/oB3q0YSrObsf0J5xnifA=
Message-ID: <6d4bc9fc0708280706q278fe285kdf90a27f40d2a55@mail.gmail.com>
Date: Tue, 28 Aug 2007 16:06:41 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
In-Reply-To: <Pine.LNX.4.64.0708281515340.3018@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no>
	 <46CF68C4.9040506@shaw.ca>
	 <6d4bc9fc0708250637g10c75f44x20ae1533874c986a@mail.gmail.com>
	 <Pine.LNX.4.64.0708281515340.3018@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have not had any issues, i swapped the cable because a while ago i
had to check the connection of the drive after the bios failed to
detect the drive. That is why i considered that a posibility. Kernel
2.6.18 does not have NCQ support for nvidia chipsets, so that cannot
be it.

Maarten.

On 8/28/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 25 2007 15:37, Maarten Maathuis wrote:
> >
> >A broken cable seems like a realistic possibility, so i swapped it for
> >another cable. I will try if that solves the problem.
>
> Hi, did you have any success/failure, other updates?
> I am facing a similar problem (just posted to linux-ide@vger.kernel.org),
> but also with 2.6.18, and it does not look like an NCQ or loose cable problem (got a
> backplane, and sda is working normal).
>
>         Jan
> --
>
