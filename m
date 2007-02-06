Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXBFCyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXBFCyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbXBFCyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:54:08 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:43097 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050AbXBFCyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:54:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uqMInFt6tKR8IgXY3Rg/Xu2mU5OFVBsIOyGh4AQWH5EP34Upi35MOer8G3oVbN3j5VaLbm0F02lihUSo/jwS2loir9BpLAq8g4Km6NXqqQGbdl7Tw3F0wh/vyFKdPm6h6jga8t8x+XfvIrVTR2HmIBowjAftuXZDDqy5i5ETIh0=
Message-ID: <6d6a94c50702051854u7047ce1ds997faa9f79c1d66a@mail.gmail.com>
Date: Tue, 6 Feb 2007 10:54:06 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] Blackfin: serial driver for Blackfin architecture against Linux kernel 2.6.20
Cc: "Wu, Bryan" <Bryan.Wu@analog.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
In-Reply-To: <20070205104619.72cfd914@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D3664A3D9376A94BB603EE19E4AA246D10D64760@nwd2exm4.ad.analog.com>
	 <20070205104619.72cfd914@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 2/5/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
>
> Likewise - why this not locks ?
>
>
> Other than the locking bits looks ok, although has rather a lot of ifdefs

Thanks to point it out. It should be fixed in the coming patch.

Thanks,
-Aubrey
