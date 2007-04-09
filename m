Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXDIPRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXDIPRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXDIPRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:17:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:62731 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXDIPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MDlzu0Wz3OsYW6w9BEi/FTE5g9HOsASYmKMC6j5w7BXGJxocHUKazLCvpcrUXljoKG7f47tbjcbXpt4WAHEkLk8LONSiHoqlw6sW52uTdxi+Rtk/0PetgqFEKzlE5Zj9+LVcKh+aMZsfexsKykxJuWoaE05dBkdvOl6YKKLMcL0=
Message-ID: <d120d5000704090817q16686abcu1d49b480a07eeca0@mail.gmail.com>
Date: Mon, 9 Apr 2007 11:17:42 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Nicolas Boichat" <nicolas@boichat.ch>
Subject: Re: [PATCH] Apple SMC driver - fix input device
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, rlove@rlove.org, linux-kernel@hansmi.ch
In-Reply-To: <461A455C.9040508@boichat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7C083.7090504@boichat.ch> <45FE1D44.8000805@boichat.ch>
	 <200703221137.35906.dtor@insightbb.com> <461A455C.9040508@boichat.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 4/9/07, Nicolas Boichat <nicolas@boichat.ch> wrote:
> Hi Dmitry,
>
> Sorry I did not receive your message originally, someone else pointed it
> to me recently, and I recovered it from LKML archives.
>

For some reason your server does not like @insightbb.com addresses.

>
> - Invert y axis on input device.
> - Only activate the input device polling timer when the device is open.
> - Others minor fixes asked by Dmitry Torokhov.
>
> Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
>

You may add:

 Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
