Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZIUVWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZIUVWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbZIUVV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:21:59 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:48852 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZIUVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:21:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uNO28/s78qqG4c1jKZhIevr3po7WjewPuf+0L9/yLpktA+PkCpWAvy8/kwva2JfZeM
         xmP/ohJ7/oPoI/4wa1ydTyepd9o3zJElKxQr5MQeiUKwqEVPHnhmcoGAH4L7JnQcPyWB
         8dwfXsxo0yVCgBXM78K9oGbmgdXkCvM7/PUUc=
MIME-Version: 1.0
In-Reply-To: <20090921203509.GA648@Chamillionaire.breakpoint.cc>
References: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
	 <4A474EFF.5030607@cs.helsinki.fi>
	 <19f34abd0907011327h7e90ec68r7ad0ed8666abafac@mail.gmail.com>
	 <20090921203509.GA648@Chamillionaire.breakpoint.cc>
Date: Mon, 21 Sep 2009 23:22:01 +0200
Message-ID: <19f34abd0909211422n65c5802cj8fab1240ba14246a@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: depend on HAVE_ARCH_KMEMCHECK
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/21 Sebastian Andrzej Siewior <sebastian@breakpoint.cc>:
> * Vegard Nossum | 2009-07-01 22:27:32 [+0200]:
>
>>2009/6/28 Pekka Enberg <penberg@cs.helsinki.fi>:
>>> Sebastian Andrzej Siewior wrote:
>>>>
>>>> to make it selectable if it is available
>>>>
>>>> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>>>
>>> Looks good to me! Thanks.
>>>
>>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>>Applied, thanks.
>
> This patch did not make it into v31. Do you thing it is possible that it
> will reach v32?

Yes. I will send a pull request tonight :-)


Vegard
