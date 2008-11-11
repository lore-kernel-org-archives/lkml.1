Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYKKGOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYKKGOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYKKGOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:14:38 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:33316 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYKKGOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:14:37 -0500
Message-ID: <491922C9.9090006@miraclelinux.com>
Date: Tue, 11 Nov 2008 15:14:33 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: fix grub spell
References: <20081111114723.6176.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081111114723.6176.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.4.348488, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.11.11.60414
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI-san

I do agree this.
I think also that GRUB is correct.

Regards,
Naohiro Ooiwa


KOSAKI Motohiro さんは書きました:
> I met okuji-san (GRUB maintainer) yesterday.
> He said GRuB isn't correct spell and he want to fix it.
> 
> So, I'd like to do that.
> 
> 
> ------------------------------------------------------------
> GRuB isn't correct spell.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  Documentation/x86/boot.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/Documentation/x86/boot.txt
> ===================================================================
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -349,7 +349,7 @@ Protocol:	2.00+
>  	3  SYSLINUX
>  	4  EtherBoot
>  	5  ELILO
> -	7  GRuB
> +	7  GRUB
>  	8  U-BOOT
>  	9  Xen
>  	A  Gujin
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

