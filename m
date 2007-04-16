Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXDPPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXDPPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030736AbXDPPM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:12:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:34086 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030686AbXDPPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RJpC1DPKq04YZ4256SKDUN03fGYj0Iy3U0qRqubvSRfpajiwWWmEDrK+mheKJhOKRbDxMr5csZ8x6KpK410buEb9tVt+FUFe6hZtbVLaolphoCwVV/72AShXkGKeOXhdPL3jOpxb7zEe0G50OIltMz0j16Qs9CbLIfvIMGaL5ng=
Message-ID: <75b66ecd0704160812k79fc5b18j499ec7b91333df95@mail.gmail.com>
Date: Mon, 16 Apr 2007 11:12:26 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: John <linux.kernel@free.fr>
Subject: Re: Disabling x86 System Management Mode
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46235EA9.8060100@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46235447.3080000@free.fr> <46235EA9.8060100@free.fr>
X-Google-Sender-Auth: d2a1e822e3695184
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, John <linux.kernel@free.fr> wrote:
> Chipset: VIA Pro133T
> http://www.via.com.tw/en/products/chipsets/legacy/pro133/
> VT82C694T north bridge + VT82C686B south bridge
>
> AFAIU, the south bridge can be a source of SMIs.
> Can the north bridge also be a source of SMIs?
>
> What I/O ports do I need to write to, and what values should I write to
> these ports, in order to prevent the VT82C686B from sending SMIs?
>

Check out some of the links in this thread:

http://www.embeddedrelated.com/usenet/embedded/show/50333-1.php

Lee
