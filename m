Return-Path: <linux-kernel-owner+w=401wt.eu-S1765853AbXHDTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765853AbXHDTPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765338AbXHDTPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:15:08 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:34338 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765107AbXHDTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:15:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fVGbayAjlqe5iNlos7eB17BgwjMUen8FjFYGIjq03uVN3VtpTbUyMESthiCChcmhLVcG1RndgEeyYN6q84SmclTYUWLgmuiCwTzQDW288EkRBNutNFdXSJYkqrZrMIpuoHTjrkliTfQdQTJcrSdCdLclnWi5VAGhtBAM8H+vnc0=
Message-ID: <9a8748490708041215x618af981kded51e7fb3a6c469@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:15:04 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH 2/2] Group multiport serial card documentation under Documentation/serial
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <200708041405.58837.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705222225.39949.rob@landley.net>
	 <200705230025.45007.rob@landley.net>
	 <Pine.LNX.4.64.0705230922580.19474@anakin>
	 <200708041405.58837.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Rob Landley <rob@landley.net> wrote:
> Signed-off-by: Rob Landley <rob@landley.net>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
> --
>
>   Equivalent to:
>
>   git-mv sx.txt stallion.txt specialix.txt rocket.txt riscom8.txt \
>     computone.txt hayes-esp.txt moxa-smartio serial
>
>   Again, just confirmed it still applies.
>
> diff --git a/Documentation/computone.txt b/Documentation/serial/computone.txt
> similarity index 100%
> rename from Documentation/computone.txt
> rename to Documentation/serial/computone.txt
> diff --git a/Documentation/hayes-esp.txt b/Documentation/serial/hayes-esp.txt
> similarity index 100%
> rename from Documentation/hayes-esp.txt
> rename to Documentation/serial/hayes-esp.txt
> diff --git a/Documentation/moxa-smartio b/Documentation/serial/moxa-smartio
> similarity index 100%
> rename from Documentation/moxa-smartio
> rename to Documentation/serial/moxa-smartio
> diff --git a/Documentation/riscom8.txt b/Documentation/serial/riscom8.txt
> similarity index 100%
> rename from Documentation/riscom8.txt
> rename to Documentation/serial/riscom8.txt
> diff --git a/Documentation/rocket.txt b/Documentation/serial/rocket.txt
> similarity index 100%
> rename from Documentation/rocket.txt
> rename to Documentation/serial/rocket.txt
> diff --git a/Documentation/specialix.txt b/Documentation/serial/specialix.txt
> similarity index 100%
> rename from Documentation/specialix.txt
> rename to Documentation/serial/specialix.txt
> diff --git a/Documentation/stallion.txt b/Documentation/serial/stallion.txt
> similarity index 100%
> rename from Documentation/stallion.txt
> rename to Documentation/serial/stallion.txt
> diff --git a/Documentation/sx.txt b/Documentation/serial/sx.txt
> similarity index 100%
> rename from Documentation/sx.txt
> rename to Documentation/serial/sx.txt

Again I have to point out that you are neglecting to update
Documentation/00-INDEX

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
