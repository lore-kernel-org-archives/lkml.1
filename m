Return-Path: <linux-kernel-owner+w=401wt.eu-S1764699AbYETJyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699AbYETJyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763374AbYETJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:53:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21013 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762129AbYETJxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=CJ4Vf+zy1UtqybKsywci89aDSFiwZMUVcsfs7Zc690FLSxhpmJXbQaclSHopBduL5S8KSTjhoB61B91tzfsSlKLLYCHcIYIKFHjzBpuHn/RxhfVdZQuH5/kSX3Tc1uME4eX/rfYDkEFVcQ8ACXGMWdsHheRDIl+YXRdBHC0FUvk=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 05/15] rfkill: fix minor typo in kernel doc
Date: Tue, 20 May 2008 12:08:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-6-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1211136485-19878-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201208.38971.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> Fix a minor typo in an exported function documentation
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  net/rfkill/rfkill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 4e10a95..f95081a 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -412,7 +412,7 @@ int rfkill_register(struct rfkill *rfkill)
>  EXPORT_SYMBOL(rfkill_register);
>  
>  /**
> - * rfkill_unregister - Uegister a rfkill structure.
> + * rfkill_unregister - Unregister a rfkill structure.
>   * @rfkill: rfkill structure to be unregistered
>   *
>   * This function should be called by the network driver during device


