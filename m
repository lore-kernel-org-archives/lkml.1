Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbYD1ISV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbYD1ISV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765843AbYD1ISM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:18:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:30964 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765673AbYD1ISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PlTJj8qfgdh72vR+4SivqEwHjTZzfSW+MwqG17BDkAFqaaGI4xsJpIy42fb+We9Rg+6TLq0XWilwb/6MMHxepfkQ8we4G3Mkgeg88dchTm9NxvVysHEYSoAbjy10lxl13LjqL1doZaNPV9TSb0+A8/jFLd6Pd/UF8L13IPavw60=
Message-ID: <1ba2fa240804280118l5f813b38n8291789342b1d802@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:18:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Cc: "Luca Tettamanti" <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "Priit Laes" <plaes@plaes.org>
In-Reply-To: <20080428075452.GB16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426203408.GA12074@dreamland.darkstar.lan>
	 <20080428074531.GA16379@cs181133002.pp.htv.fi>
	 <20080428075452.GB16379@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Apr 28, 2008 at 10:45:31AM +0300, Adrian Bunk wrote:
>  > Can you send the .config that gives this problem?
>
>  Scrap that, I already got the problem (and your patch looks right).
>
>

I think it's time to be applied so we won't get another 5 of them.
Please add also  Priit Laes <plaes@plaes.org>  as he was first to
provide a patch

Thanks
Tomas

>  cu

>  Adrian
>
>  --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>
> the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Please read the FAQ at  http://www.tux.org/lkml/
>
