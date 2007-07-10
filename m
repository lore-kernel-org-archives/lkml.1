Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXGJOwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXGJOwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXGJOwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:52:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:38074 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbXGJOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=IKT7ujWu8txL/iXbgmrJB3HKMON0AqDfD+qu0QP+yGS5SCozVGsCIAFXbXScHPuYjYJM8joCXvlaK6FVBLBTkK1+Muh9dsVrm6DICpY+hEvw3v9KsxPuyjs6m4EOIBDQQ7xmeSP9Si6FjVnSASlC9iOJCk0vIy5NjtUUIeRrtTA=
Message-ID: <46939CBC.5060502@gmail.com>
Date: Tue, 10 Jul 2007 10:50:36 -0400
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: David Brownell <david-b@pacbell.net>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
References: <20070628103619.GW13886@enneenne.com>	<200706281453.23414.david-b@pacbell.net>	<4684CAF7.9050201@gmail.com>	<200706300646.14399.david-b@pacbell.net> <20070709135109.GO11451@enneenne.com>
In-Reply-To: <20070709135109.GO11451@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Vernon Sauder <vernoninhand@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> That's what I wish to do... I wish cleaning up as much possible my
> pxa27x version af the driver so we can have something common where we
> can work on.
>
> Sorry for the delay but in these next days I'll read back all your
> suggestions and I'll provide a new patch ASAP.
>
> However I would like avoiding to remove what I did on
> usb_ep_autoconfig() since I got functional g_ether device with RNDIS
> support... there could be another way to resolve this problem?
>
> Thanks a lot,
>
> Rodolfo
>   
Rodolfo,

I am eager to see an "official" USB driver. I have used a patch I found 
on the web that was attributed to you for 2.6.20 in our recent project. 
It patched cleanly and has worked fairly well. I am busy with other 
projects right now but might be able to squeeze some time to test on our 
board.

We have a custom PXA 270 board and we are moving to the PXA 320. I was 
very concerned that we have no 270 driver in mainline and no hope of a 
320 driver.

Regards,
Vern
InHand Electronics, Inc.
