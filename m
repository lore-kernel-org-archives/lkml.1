Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZKOXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZKOXTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 18:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZKOXTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 18:19:34 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55082 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZKOXTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 18:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CRpj/ezrOWaN3Mv+p9LEaVh8Zhh0ptMrltvhXRkxLdGyBPUQhuiBUu/A5m8iR+7gBs
         fAKN7L69zZ4DPZR2IQtlgOzFRlu2KsD9v3YmawS/l2B7keaklNGYoMN6QuCy39WsDmBA
         K7dorLlyWtqdaKQPs4f+o+zuP4iDecel+pOGI=
MIME-Version: 1.0
In-Reply-To: <1258319857.6556.59.camel@invitado-laptop>
References: <1258319857.6556.59.camel@invitado-laptop>
Date: Mon, 16 Nov 2009 09:19:28 +1000
Message-ID: <21d7e9970911151519h535f6063t4924ccf71286cdee@mail.gmail.com>
Subject: Re: intelfb maintainer
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Iban_Rodr=EDguez?= <iban.rodriguez@ono.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/16 Iban Rodríguez <iban.rodriguez@ono.com>:
>
>    Hello,
>
>    I have found a problem in the intelfb driver. I've tried to send an
> e-mail to Sylvain Meyer (maintainer) but I've received the mail back
> because of 'user unknown'. Could you tell me who I can send the report?
>

intelfb is mostly deprecated in favour of kernel modesetting drivers,

I also used to help maintain it, but its mostly to be left for dead,

linux-fbdev-devel@lists.sf.net is probably the best plaec to send stuff.
(but don't be surprised if nobody really cares).

Dave.

>    Thank you very much.
>
>    Iban Rodríguez.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
