Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYGFT1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYGFT1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 15:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbYGFT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 15:26:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8128 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYGFT0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 15:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mF+Izv1BUycDQ5SVb63sABQwVXNmaGoWOtzSG6nQ24tm9SwRjwNJD5y6OiOmADFNWG
         CHPdI1iN+560pwuczkM9dSTzYZo2z03X9j7oQ80rJl6mV7dzLjipiviSufZCA+Md8h+z
         dKqe6Uo1qb68SK3CWNlgtjCDjuaG/826DM6F0=
Message-ID: <bc64b4640807061226m16f597a8m585ef2101bd6b7a1@mail.gmail.com>
Date: Sun, 6 Jul 2008 23:26:50 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] [ARM] Tosa: remove double inclusion of linux/delay.h
Cc: rmk+kernel@arm.linux.org.uk, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670807060858nf8ec980gcd0475ccdc55b94d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060858nf8ec980gcd0475ccdc55b94d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/6 Alexander Beregalov <a.beregalov@gmail.com>:
> From: Alexander Beregalov <a.beregalov@gmail.com>
>
> The patch applies to the linux-next tree.
>
> [ARM] Tosa: Remove double inclusion of linux/delay.h
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Acked-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

Will you submit to the Russell's patch tracker or shoud I do it?

-- 
With best wishes
Dmitry
