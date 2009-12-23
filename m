Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZLWSiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZLWSiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZLWSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:38:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35282 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZLWSiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WPQq1VrumtZtRucBR/VzpaUWHdHAQzNjCyIVzQk8FsLBIQ1bbchsWtKk1ig/JBm/bE
         TixMvnk8fSuSU1eqNZpsgDXzXfwTd7j+7e1SmDFHrdKIKQNGH15E8clGo7BuXFG5fQmK
         aS6UrN/cOO4BqxMVeEZjM88oUv+LSeIdFKaG8=
MIME-Version: 1.0
In-Reply-To: <200908202242.31778.PeterHuewe@gmx.de>
References: <200908202242.31778.PeterHuewe@gmx.de>
Date: Wed, 23 Dec 2009 19:38:20 +0100
X-Google-Sender-Auth: d0bf42ec47cdb1c1
Message-ID: <10f740e80912231038r6d58cd34ke01051d82095f12c@mail.gmail.com>
Subject: Re: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 21:42, Peter Huewe <PeterHuewe@gmx.de> wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
>
> Trivial patch which adds the __init macro to the module_init
> function and all of its helper functions of char/vme_scc.c
>
> Alan or Geert, please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial tree.

Thanks, applied.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
