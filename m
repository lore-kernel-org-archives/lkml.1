Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYGFUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYGFUcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYGFUcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:32:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:17236 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbYGFUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vlu5s0Ke0LAdRYMO6eIF2tVBmrrW0mraI7j4sFYP86gkEyXoSz1hdY7xqe5xuAI3LS
         zFc4ZcDFXjr01SkeuOMtiGPhP8ns6W+2NypvRclzR/Ucx6nVdgGndLyVnyu3lfNruNMj
         OH+Y5wFLEruU3705KTqLtM7G+Yhrcv0e5xEfc=
Message-ID: <a4423d670807061332y62eb0024g396cf21d3549d855@mail.gmail.com>
Date: Mon, 7 Jul 2008 00:32:29 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: Dmitry <dbaryshkov@gmail.com>
Subject: Re: [PATCH] [ARM] Tosa: remove double inclusion of linux/delay.h
Cc: rmk+kernel@arm.linux.org.uk, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <bc64b4640807061226m16f597a8m585ef2101bd6b7a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060858nf8ec980gcd0475ccdc55b94d@mail.gmail.com>
	 <bc64b4640807061226m16f597a8m585ef2101bd6b7a1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/6 Dmitry <dbaryshkov@gmail.com>:
> 2008/7/6 Alexander Beregalov <a.beregalov@gmail.com>:
>> From: Alexander Beregalov <a.beregalov@gmail.com>
>>
>> The patch applies to the linux-next tree.
>>
>> [ARM] Tosa: Remove double inclusion of linux/delay.h
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> Acked-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>
> Will you submit to the Russell's patch tracker or shoud I do it?

I do not know what it is, please do it if you can.
