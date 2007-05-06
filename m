Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbXEFHGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbXEFHGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbXEFHGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:06:36 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:8648 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEFHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hBcWQcBc60gG9136jfNkgA/kfatwXu/LSEnsqxy2miFDfHeF8NRhRCBErGeg2dSElPUgxIM4DtYL5mRhUYwKELUnVsyMJTv+8i81329RQTsaeDEpkoJNz90JGL9KSnKS0MFl99mTLLT1+yjPoPKBki/MEh2Dt0+iawX+4Iue760=
Message-ID: <5486cca80705060006y38da02e1yddb0059a9b717b3a@mail.gmail.com>
Date: Sun, 6 May 2007 09:06:34 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Paul Fulghum" <paulkf@microgate.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200705052035.58782.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178384675.3379.26.camel@x2>
	 <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com>
	 <200705052035.58782.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Oliver Neukum <oliver@neukum.org>:
> Am Samstag, 5. Mai 2007 20:08 schrieb Antonino Ingargiola:
> > Now I don't want to abuse your kindness, but I (personally) would be
> > *really* interested in a similar fix for the FTDI usb-serial driver,
> > because many measurements I do use an FTDI device.
>
> Does this work?
>

Thanks for the patch! Alas, I will have access to an FTDI device only
on Tuesday, then I'll test it and report results.

>         Regards
>                 Oliver

Regards,

  ~ Antonio
