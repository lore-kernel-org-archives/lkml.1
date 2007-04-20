Return-Path: <linux-kernel-owner+w=401wt.eu-S1767091AbXDTOSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767091AbXDTOSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993256AbXDTOSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:18:05 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:9913 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993034AbXDTOSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WHqQUFoUOTp1LaHplvtMQTJCiEYju7w7WUou+liSCadZSM2ELUgqCm73uzG/WisAEdp9g+/COmBFdBxCidteLhhYpS3nViuyYomNOdYqVI9r8rOuOXBccIL1Nawo8Glk6YxeIJyzXhPuDJkiUPqx5mTP21UhoUCVovgXJ31I7Ho=
Message-ID: <4af2d03a0704200718n4118570fy6486cbd803445630@mail.gmail.com>
Date: Fri, 20 Apr 2007 16:18:01 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Jan Yenya Kasprzak" <kas@fi.muni.cz>
Subject: Re: [PATCH 1/3] Char: mxser_new, fix recursive locking
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070420141551.GQ22955@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20225157853131727049@wsc.cz>
	 <20070420131210.166fcd40@the-village.bc.nu>
	 <20070420141551.GQ22955@fi.muni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Jan Yenya Kasprzak <kas@fi.muni.cz> wrote:
>         I did as you suggested, and I am not able to reproduce the problem
> now. The patch is attached. I think it is quite minimal, so it should be
> safe to apply it. What do you think, Jiri?
>
> Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Acked-by: Jiri Slaby <jirislaby@gmail.com>
