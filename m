Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbXEUQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbXEUQQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXEUQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:16:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30402 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXEUQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qu0ZNmx6gKhpSiDG3/IwOo9C48fd2dDHq54gM2ikxZ+owxGhtbDfA5js36LPYY0DQKb5I+zDEp+0ZF2wJ6bfwCxlPEdAX1FRD1cOvLniVnofa3K9nD5NKA9DgeigocPVISLR/laoR4ythhCicKBjQsUjj732rMD2pNaZ/UCVPR8=
Message-ID: <21d7e9970705210916r152ecaf4jafc2b0c1ce3914ae@mail.gmail.com>
Date: Mon, 21 May 2007 17:16:20 +0100
From: "Dave Airlie" <airlied@gmail.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Jon Smirl" <jonsmirl@gmail.net>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705201610.32170.jbarnes@virtuousgeek.org>
	 <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
	 <200705210809.25206.jbarnes@virtuousgeek.org>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.
>
> There is more to fbdev than mode setting. It is also how non-x86
> platforms achieve their boot display. How will boot display be handled
> with the your design? What about console display on non-x86 platforms?
> Loading both fbdev and the new code puts us right back into the
> multiple driver fight we have today.
>
> If the kernel graphics system is going to get rewritten the rewrite
> needs to address all of the existing problems.
>

We already have fbcon working perfectly on top of this layer... so you
might want to actually look at the developed code..

Dave.
