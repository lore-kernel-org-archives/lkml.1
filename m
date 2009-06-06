Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZFFHGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZFFHGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZFFHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:06:37 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53743 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZFFHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SQdDpFpFOtJFYPw0SiE7OujcstX1mkNH8jn5ForWKiwdUFRDwFK5eiflvk6b6Zu5FV
         gdMz3wk67IFmFWvcuvrdB58lCAKwQJXut7cmsaOc/OxaJTXpw75Ey78LwTR6nx0icce/
         keMkPewf+1p9EsRS0aNjDcssCD0uQuYeM42xY=
MIME-Version: 1.0
In-Reply-To: <20090605.175825.168276404.davem@davemloft.net>
References: <20090605091229.GA25280@doriath.ww600.siemens.net>
	 <20090605094619.GB23085@build.ossfans.org>
	 <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
	 <20090605.175825.168276404.davem@davemloft.net>
Date: Sat, 6 Jun 2009 11:06:33 +0400
Message-ID: <bc64b4640906060006w1d623172p2595158cc5204f3b@mail.gmail.com>
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of 
	802.15.4 devices
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: slapin@ossfans.org, johannes@sipsolutions.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/6, David Miller <davem@davemloft.net>:
> From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>
> Date: Fri, 5 Jun 2009 14:45:06 +0400
>
>
>  > Could you please send an incremental patch on top of this serie? I
>  > hope that my last
>  > push can be pulled/merged and I don't want to redo all commits.
>
>
> Dmitry, no shortcuts ok?
>
>  Just respin the series and resend it just like anyone else has to.
>
>  The changes just aren't ready, and until they are you'll need to
>  respin them like this a few more times.

I'm on vacation for the next following days. In the mean time Sergey
Lapin will continue working on this patchset, updating it to pass
through review.

-- 
With best wishes
Dmitry
