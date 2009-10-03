Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZJCGXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZJCGXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbZJCGXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:23:43 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:39358 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZJCGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Mj+Zmr1G0K2o3/b1MzxbBvAA259BEJAdqZr/uPt1x4qOCBD9hK6xMUhE+t5EHL05b3
         +jN357dvR4xUHguyfcqfPFVp8kwOgW88mQ4XB9J2f7sqaE4Cg63Pr/+NwjxNm9AH3Id1
         E4HC0nKhquh1mej8NvYpaj3qCbbIf1a4PmiEw=
MIME-Version: 1.0
In-Reply-To: <200910021535.27820.corentincj@iksaif.net>
References: <b9df5fa10910012231u38f49eeeoe1d0bcc9eafd53d6@mail.gmail.com>
	 <200910021535.27820.corentincj@iksaif.net>
Date: Sat, 3 Oct 2009 12:23:46 +0600
Message-ID: <b9df5fa10910022323x1031c183ka1f2d540a6e1226e@mail.gmail.com>
Subject: Re: [PATCH] eeepc_laptop: Properly annote eeepc_enable_camera().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: acpi4asus-user@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/09, Corentin Chary <corentincj@iksaif.net> wrote:
>  Hi,
>  Your patch is broken, probably due to wordwrap.

Hi Corentin, not sure how it got broken. On my system it applies well.
And this is the way I usually send patches.

>  $ git am /tmp/\[PATCH\]\ eeepc_laptop\:\ Properly\ annote\ eeepc_enable_camera\(\)
>  Applying: eeepc_laptop: Properly annote eeepc_enable_camera().
>  fatal: patch fragment without header at line 5: @@ -350,7 +350,7 @@ static const struct rfkill_ops eeepc_rfk
>  Patch failed at 0001 eeepc_laptop: Properly annote eeepc_enable_camera().
>
>  Please re-send it (you can use git send-emails).
Okay, I'm re-sending it.
>  Also, please name it eeepc-laptop, not eeepc_laptop
>  Thanks,

Thanks,
Rakib

>  --
>  Corentin Chary
>  http://xf.iksaif.net
>
