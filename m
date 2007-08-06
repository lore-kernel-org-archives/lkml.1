Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXHFKlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXHFKlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXHFKlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:41:04 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:56099 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXHFKlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iiX8V/jTkmM5yoRq3pDJcS1seRjwYzII4BJDHnS7GcomjDLq7Pke7hbwfbPBEqaVHzqiIDRXoroH8fW+Q6hXx3MYIiPE+ZI2aMCr2vkDkjAwAJMZ+m9X5E8fgZw70i7+8NzPgKZzVTTPhA176CoS61wzFTs67hoMcTSMFxJlI8A=
Message-ID: <3efb10970708060341s65c53a8bk81a99ce615b668fb@mail.gmail.com>
Date: Mon, 6 Aug 2007 12:41:00 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Nathan Williams" <ngwilliams@gmail.com>
Subject: Re: MODULE_LICENSE usage
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
X-Google-Sender-Auth: 303a00f76dd55084
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nathan,

There has been a lot of discussion about this in the past.
Read for example this thread: http://lkml.org/lkml/2006/12/13/370
This will probably clears some things up.

Remy

2007/8/6, Nathan Williams <ngwilliams@gmail.com>:
> Hi,
>
> I'm working on a driver for an ADSL modem which requires the use of a
> binary library from the chipset manufacturer.  All my source code is
> GPL, so that others are free to distribute and modify the driver.
> After asking the FSF for advice and working through their FAQ, I've
> given permission for the binary library file to be used with the GPL
> source code and be re-distributed with it.
>
> I would like to know if I'm permitted to use MODULE_LICENSE("GPL") in my module.
>
> Additionally, I'm unsure of what is the meaning of
>
> "GPL and additional rights"     [GNU Public License v2 rights and more]
>
> Is it correct to say that my driver is licensed under GPL with
> additional rights to use the binary library file?
>
> Thank you,
> Nathan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
