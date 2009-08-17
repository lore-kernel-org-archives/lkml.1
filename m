Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbZHQJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbZHQJTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbZHQJTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:19:50 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:65244 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbZHQJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kV17CF/jqQjL4Dct2PV0otCinNGlE9nEtXK70CTI8PmBV728Ruq9nghUaV4omjvQHc
         Lzhf0lMV6lwdLA1dE9FemSPMbJwoMRECbIghVDlLNnQ0a7KUUomarNNqLT6tuChz8fLc
         w6VpYx+owZUNOi3w70nkwuZ0rRl90QIOfEDU0=
MIME-Version: 1.0
In-Reply-To: <20090817091458.GR4302@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
	 <20090804201032.GB30892@infomag.iguana.be>
	 <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
	 <20090805070822.GC30892@infomag.iguana.be>
	 <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com>
	 <20090805103127.GF30892@infomag.iguana.be>
	 <4A79873A.5010504@gmail.com> <4A88C328.5040706@gmail.com>
	 <20090817091458.GR4302@infomag.iguana.be>
Date: Mon, 17 Aug 2009 17:19:51 +0800
Message-ID: <e68bb3470908170219i6d0a26c3r57e2ca2b4fe01b76@mail.gmail.com>
Subject: Re: [PATCH v2] Add watchdog driver for w90p910
From: Wan ZongShun <mcuos.com@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wim,

2009/8/17 Wim Van Sebroeck <wim@iguana.be>:
> Hi Wan,
>
>> At the same time, I renamed this driver name, due to I
>> have changed the corresponding device name in my arch file.
>
> Isn't it best to rename the driver in drivers/watchdog also to nuc900_wdt.c ?

Of course , If you permit :).
Waiting for me, I will fix the patch regarding this, and re-submit it to you.

Thanks for your help.

> Thanks,
> Wim.
>
>



-- 
Wan z.s
