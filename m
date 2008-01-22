Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYAVUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYAVUqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYAVUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:46:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:43318 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYAVUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:46:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lDPm18V6B2026lJse6vwcXFEMJLNXIxWFb7cFd3ai+F8i9WKACGpOSV/0HfIxlJ+2FTyHm4i838/SiT1oJNO0cGjAODnW3JN4AttU8KnePxxo26uD0Y4Ypve6hdbkSX2MhnYy5rMUM4N7g45pKXEYqqOJk8SCt+BunQ27wDv0mU=
Message-ID: <2c0942db0801221246u678d2a20xef9cf93ee28eaf51@mail.gmail.com>
Date: Tue, 22 Jan 2008 12:46:32 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Manuel Reimer" <Manuel.Spam@nurfuerspam.de>,
       "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Massive IDE problems. Who leaves data here?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fn5jsn$ful$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fn5ivo$ck2$1@ger.gmane.org> <47965138.8060603@garzik.org>
	 <fn5jsn$ful$1@ger.gmane.org>
X-Google-Sender-Auth: 073d82013b948dc9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please always do a reply-to-all for this email list.)

On Jan 22, 2008 12:40 PM, Manuel Reimer <Manuel.Spam@nurfuerspam.de> wrote:
> Jeff Garzik wrote:
> > If your IDE interface is complaining about BadCRC errors, then it's
> > complaining about hardware problems (bad cable, etc.)
>
> The cable already has been replaced three times. I even got sure to
> *not* bend the cable. This all doesn't help.
>
> May a bad cable really cause corrupted data?
>
> I also have such messages for my cdrom drive (the bad sector messages at
> the end of the log for drive hdc). I replaced the 40 pin cable with a
> new 80 pin one and still have the errors...

Bad or almost bad power supplies can cause lots of unhappy problems
such as these. If you have another power supply laying around, it can
be worth swapping them out. Double-checking that your CPU fan is still
spinning, and that memtest86+ doesn't show any errors doesn't hurt
either.
