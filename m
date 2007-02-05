Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXBEJNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXBEJNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbXBEJNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:13:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:13782 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXBEJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nfkO5AfethVh0fHRqjK+pujfymqnCzDu6ImIwQg9sEGai2vdRVNMXr5DI2XJkroAHFlPzNjWPn3x8LEI9/81Etn4NEXVJkeVSYBrTAAbeTjx5sQBIGeBDGrKZIzpZInumsxowXHgmeu19tPiu0KnfxeXF/sJXn26RjD4XVG8pdA=
Message-ID: <8bd0f97a0702050113s7a62cf4cn960f56a91a769469@mail.gmail.com>
Date: Mon, 5 Feb 2007 04:13:22 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH 3/3] Blackfin: documents and maintainer patch
Cc: akpm@osdl.org, alan@lxorguk.ukuu.org.uk, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <D3664A3D9376A94BB603EE19E4AA246D10D64762@nwd2exm4.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <AcdI+C4fI9r0HkHsSYWAfYjpryRQrg==>
	 <D3664A3D9376A94BB603EE19E4AA246D10D64762@nwd2exm4.ad.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Wu, Bryan <Bryan.Wu@analog.com> wrote:
> --- git-merge.orig/linux-2.6/MAINTAINERS
> +++ git-merge/linux-2.6/MAINTAINERS
> @@ -637,6 +637,40 @@
> +BLACKFIN ARCHITECTURE
> +P:     Luke Yang
> +M:     luke.adi@gmail.com

he's no longer with the linux team ;)

> +L:     linux-kernel@vger.kernel.org

i think this is an implied list so no need to explicitly state it

> +L:     uclinux533-devel@blackfin.uclinux.org

this should be uclinux-devel@blackfin.uclinux.org now

> +BLACKFIN SERIAL DRIVER
> +L:     linux-kernel@vger.kernel.org
> +L:     uclinux533-devel@blackfin.uclinux.org

same as above
-mike
