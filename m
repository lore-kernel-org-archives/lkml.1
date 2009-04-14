Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZDNSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZDNSpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbZDNSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:45:19 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:42672 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbZDNSpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VJHL4Mkc7zHdXQo59EnBv/5Xzpak2UeV6OlVIyJ03owivV9KmNhk+mPJ5cPY2IXZar
         U08jPkGKqK9325BUOhZwn4mA37H9uQKeI1XZocN/BiJbCQMy9DDrszX7WlRonSkbnTQm
         sZuE0dxaLURAqvofLsGEgriPWvKppz3ruPn1g=
MIME-Version: 1.0
In-Reply-To: <1239734197.7994.8.camel@localhost>
References: <1239734197.7994.8.camel@localhost>
Date: Tue, 14 Apr 2009 21:45:15 +0300
X-Google-Sender-Auth: 94882d969616a46d
Message-ID: <84144f020904141145q71dc6c66l14dc89e1a1c6a0d1@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS - Update KMEMTRACE pattern after file rename
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 9:36 PM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b4f1dd..d8fe7eb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3267,7 +3267,7 @@ P:        Eduard - Gabriel Munteanu
>  M:     eduard.munteanu@linux360.ro
>  L:     linux-kernel@vger.kernel.org
>  S:     Maintained
> -F:     Documentation/vm/kmemtrace.txt
> +F:     Documentation/trace/kmemtrace.txt
>  F:     include/trace/kmemtrace.h
>  F:     kernel/trace/kmemtrace.c
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
