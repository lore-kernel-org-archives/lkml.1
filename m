Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbZDQVOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbZDQVOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbZDQVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:13:21 -0400
Received: from mail-qy0-f126.google.com ([209.85.221.126]:33246 "EHLO
	mail-qy0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601AbZDQVNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sb1Zh3U+rOgm/EgS/k/Ha39k+lugATqPx3g38ip3uRhBcCPCTmDUgHAtzcLgnSWRHz
         RHLIdvMmc+ilrpa/7LXOYx3zpdmWCEnaoaLp8Mhz/P0bbLBrPcFrNzYGcjs+2LWHka4i
         M/AwlMHX1fjDXiH5wQZ4+AH7Db6tsiAypUsfY=
MIME-Version: 1.0
In-Reply-To: <1239997028.3307.496.camel@calx>
References: <1239997028.3307.496.camel@calx>
Date: Fri, 17 Apr 2009 17:13:19 -0400
X-Google-Sender-Auth: 1709a7cd17d106be
Message-ID: <7d1d9c250904171413u3cf20247i5513c415bf9c6a5f@mail.gmail.com>
Subject: Re: [PATCH] Add myself to embedded maintainers
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 3:37 PM, Matt Mackall <mpm@selenic.com> wrote:
> Impact: make more work for myself

I don't think "Impact:" has been outlawed just quite yet...  :-)

>
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

>
> diff -r 8e0f1cee0a71 MAINTAINERS
> --- a/MAINTAINERS       Sat Jan 24 15:41:13 2009 -0600
> +++ b/MAINTAINERS       Fri Apr 17 14:12:07 2009 -0500
> @@ -1627,6 +1627,8 @@
>  EMBEDDED LINUX
>  P:     Paul Gortmaker
>  M:     paul.gortmaker@windriver.com
> +P:     Matt Mackall
> +M:     mpm@selenic.com
>  P:     David Woodhouse
>  M:     dwmw2@infradead.org
>  L:     linux-embedded@vger.kernel.org
>
>
> --
> http://selenic.com : development and support for Mercurial and Linux
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
