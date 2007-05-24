Return-Path: <linux-kernel-owner+w=401wt.eu-S1762659AbXEXFzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659AbXEXFzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXEXFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:55:35 -0400
Received: from smtp5.freeserve.com ([193.252.22.159]:1065 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048AbXEXFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:55:34 -0400
X-ME-UUID: 20070524055531290.46CAB1C00081@mwinf3403.me.freeserve.com
Message-ID: <465528CD.4080209@cjsoftuk.dyndns.org>
Date: Thu, 24 May 2007 06:55:25 +0100
From: Chris Malton <chrism@cjsoftuk.dyndns.org>
Organization: CJSoft UK
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NCPFS 255 character support?
References: <465448E2.3090104@cjsoftuk.dyndns.org> <20070524012022.673fdf8f@the-village.bc.nu>
In-Reply-To: <20070524012022.673fdf8f@the-village.bc.nu>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms060206080502020205020303"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060206080502020205020303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan,

If NCPFS has little use these days, how are the linux users meant to 
sign on to Novell networks without using the (IMHO) bloatware provided 
by Novell?

In fact, Novell's client only work on SLED first time lucky (everything 
else needs extra libs and a lot of work) so it's hardly much use.  I'll 
have a go with the ls, and strace ls and the dodgy file and see what 
happens.

If there's a pointer to ncpfs, I might take a brief look and see what 
happens.

Thanks,
Chris

Alan Cox wrote:
> I did see it but couldn't match it against any other reported kernel
> problems (mind you I don't think ncpfs has much use nowdays). Only thing
> I could think to suggest is trying "LANG=C ls" instead, which if it works
> means its a userspace issue (or Unicode mapping one). An strace of an ls
> going wrong might also give clues.
> 
> Alan
> 
> 


--------------ms060206080502020205020303
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
--------------ms060206080502020205020303--

