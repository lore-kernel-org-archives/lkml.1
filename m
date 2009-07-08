Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZGHGcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZGHGcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758256AbZGHGcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:32:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49019 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZGHGcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TEO6JFDXxJquRpzeq7P7GW/ErtkUp2vpX68cSepcUF3KlOAFTOwPbi8zPkkT9xraNk
         u1JOizoc/DPRRc2thgxjwSeyrm4GY0c8WE24qDneohhssXCaM000s/wES9UYXpXF4BLH
         MW94ssG24gpayVmxwZjail6Hl7ViXRzyk2X+I=
MIME-Version: 1.0
In-Reply-To: <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
Date: Wed, 8 Jul 2009 09:32:43 +0300
X-Google-Sender-Auth: 68af211c6b743a21
Message-ID: <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Jul 8, 2009 at 8:55 AM, Joe Perches<joe@perches.com> wrote:
> from sections that should not have them.

What is that supposed to mean?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4da8c4d..5628b0a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3473,13 +3472,11 @@ P:      Vegard Nossum
>  M:     vegardno@ifi.uio.no
>  P      Pekka Enberg
>  M:     penberg@cs.helsinki.fi
> -L:     linux-kernel@vger.kernel.org
>  S:     Maintained

Why do you want to remove that? It's there to tell people that you're
_supposed_ to cc LKML for kmemcheck patches in contrast to subsystems
(e.g. networking) that want people to cc _their_ mailing list (keeping
LKML is optional). Hmmm?

                        Pekka
