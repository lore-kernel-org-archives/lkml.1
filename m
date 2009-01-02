Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZABQjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZABQjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZABQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:38:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:37169 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbZABQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:38:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UoGojUjciCRGZObg1Gs/i/imcQwV80qrUFkLWp7IIFk0YRvKnA34e8MJPjtDHVNPqZ
         WKXKC3mdsxSB+EKokjiNBgX0N1y2xnX87avMJJdRVmODTa2aD/+AfdALZRhwBAbvoGlF
         YfmTa6vONBkzvv0scpwzHFRd40zKIyrqNfuLE=
Message-ID: <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com>
Date: Fri, 2 Jan 2009 22:08:53 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Cc: Valdis.Kletnieks@vt.edu, "Bryan Donlan" <bdonlan@gmail.com>,
       "Ingo Brueckl" <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090102162120.GG1180@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d2974@wupperonline.de>
	 <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
	 <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
	 <20090102093801.GD1975@elte.hu>
	 <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com>
	 <11444.1230910752@turing-police.cc.vt.edu>
	 <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com>
	 <20090102162120.GG1180@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 9:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> So you want to save kernel size by making less generic kernels tailored to

My intention is to remove unwanted or useless data from kernel.

> a single box [yours in this case] - basically embedding the kernel on it?
>

So you mean choosing x86 is also EMBEDDED ? because it will not gonna
run on ARM machine.

>
> that is what CONFIG_EMBEDDED=y means in broad terms: "make the kernel more
> specific [more embedded] to a particular hw/sw combination".
>

Choosing drivers is also Embedded ?

Thanks you,
JSR
