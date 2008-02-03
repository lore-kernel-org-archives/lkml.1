Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYBCQsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYBCQsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 11:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbYBCQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 11:48:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:11439 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbYBCQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 11:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SOR4KbDsOYHq5HjMoAbFm8JPgfLz/ZsfSWAqTHnTFoN53W/XPgyMbBL5ZXHSWFZ8O2KQkfcsdEWV3j4i0nAH0E/rFHTEVSblPvoK2oXiwrlosKg0IrZYwhTftxkklAz5GgB767qXW/XsF2rpUYaX2O03i35YllKsTKv/O2xsjDg=
Message-ID: <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com>
Date: Sun, 3 Feb 2008 18:48:07 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "Greg KH" <greg@kroah.com>, "Christer Weinigel" <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47A5E67D.9040804@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>
	 <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com>
	 <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
	 <47A5E67D.9040804@davidnewall.com>
X-Google-Sender-Auth: 3cc57ee24cc4d4b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Feb 3, 2008 6:06 PM, David Newall <davidn@davidnewall.com> wrote:
> > But what I don't understand is why people insist using the Linux kernel
> > for something it clearly can never really properly support (proprietary
> > code)?
>
> That's defeatist.  Of course the Linux kernel can properly support
> ("run") proprietary code.  It would be a miserable excuse for an
> operating system if it couldn't.

I think you're missing my point: as long as the license stays the way
it is now, you can never distribute proprietary code unless you've
consulted a lawyer and even then you run the risk of being sued for
infringement if the copyright holder thinks what you have is derived
work. The GPLv2 and thus Linux was never designed to allow proprietary
code and arguing that is pointless, isn't it? There are much better
alternatives available and people interested in proprietary code
should be looking there.

                         Pekka
