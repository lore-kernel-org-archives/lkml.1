Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbXBELAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbXBELAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXBELAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:00:37 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:18398 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXBELAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CTGN6GYvUZExTRvoAjYqB/yiap6HYpyApz3nPz8r7bgKIyYFnC/sgcgvbIc+MWNicft2CDvnNO7lnl4U7Nh/LZV0meFgUe7MK7up8By24Bxdgt5SBiwwawla4tgJ2R6sDuCzRGtj6t2MAOGnNdtu8OXCyT5ZXmOrNpPIGe5fNto=
Message-ID: <8d158e1f0702050300s56dd1d9cg76e13b3a13f07de7@mail.gmail.com>
Date: Mon, 5 Feb 2007 12:00:35 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Stephen.Clark@seclark.us
Subject: Re: hdparm for lib_pata
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702031618w2249c64x18ad4d2f03ce3c69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
	 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
	 <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
	 <45C5249B.8020101@seclark.us>
	 <8d158e1f0702031618w2249c64x18ad4d2f03ce3c69@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning all,

About the reason as of why it drops to PIO mode, I might have found
the reason for this, I am just not sure if what i found is related.

When I opened my Athlon XP machine, took the cables out and replaced
them for new cables, I found out that my southbridge fan wasnt
spinning anymore, at all.

So my guess is that this chip is overheated at some point and starts
causing problems.
Now, it was always my comprehension that the southbridge does indeed
control the ATA controller but only the onboard one, so even if the
chip is having heat problems, my PCI add-on cards should still work on
full UDMA100 speed, right?

I am re-assembling my athlon board again today, and as soon as I get
the falling back to PIO mode errors again in dmesg I'll forward you
the messages, like you asked :)

If someone could shine a light on my question about the southbridge,
I'd really appriciate it, email me privately if you prefer.

Thanks!

Patrick
