Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZFETMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZFETMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZFETMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:12:23 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42891 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFETMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:12:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CPXUH58NLXDJVfKrbjI0L0NP3mfBdJO7P3KXOvxcpuToKsj9szeVe3JsFidmfa/1z5
         uWKGkgH4oxs/nshaXa+3nb9Z+x6ukcIaH6nO0lviZlRNzxKt5NvBW3C4ZfObhkjEX05O
         ifJNK89fXPm/CsbYUAzlLuAq8gLyb7H9UGrB8=
MIME-Version: 1.0
In-Reply-To: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 5 Jun 2009 21:12:03 +0200
Message-ID: <69e28c910906051212l6f6548bflf7d83c4eccf80fad@mail.gmail.com>
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 9:04 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> I'm pleased to announce we have released the source code to our
> Atheros 802.11n USB Otus/ar9170 device under the GPL. You can grab the
> source, compile and use it with the upstream ar9170 device driver.
> Patches are welcomed. The git tree available for this is at:
>
> http://git.sipsolutions.net/ar9170-fw.git
>
> For more information please visit the home page for this project is on
> our Linux wireless wiki:
>
> http://wireless.kernel.org/en/users/Drivers/ar9170.fw
>
> The ar9170 device driver home page is at:
>
> http://wireless.kernel.org/en/users/Drivers/ar9170
>
> I'd like to thank Johannes Berg and Christian Lamparter for their
> incredible contributions to the project both firmware and ar9170
> driver so far without which this would not have been possible.
>
>  Luis

Great! That's a first for any wireless chip...

BTW can we expect a similar firmware source release for ar2524/zd1211?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
