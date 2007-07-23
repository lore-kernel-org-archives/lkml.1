Return-Path: <linux-kernel-owner+w=401wt.eu-S934917AbXGWTyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbXGWTyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765527AbXGWTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:53:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:64294 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113AbXGWTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pbL6APw6sy37JKYCp6d0HrWWIjYTvqBZx6KH3t5sUt43VTvgXBKRtswt/8wXFzvOdgIXGlGdQhNKZ6DemthF2nrt0OZGRiHXwuvodJCRilyFhNNylELE+QDhgymmxswg0Lgr15paiG6wcQQ9QfadUiQjBtv8doZvOBWsW3iVRoE=
Message-ID: <9a8748490707231253q13ea1e21q757ee8f7cfaef0d1@mail.gmail.com>
Date: Mon, 23 Jul 2007 21:53:55 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH][36/37] Clean up duplicate includes in sound/ppc/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, "Geoff Levand" <geoffrey.levand@am.sony.com>
In-Reply-To: <s5hlkd7yy9k.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211704.07263.jesper.juhl@gmail.com>
	 <s5hlkd7yy9k.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 21 Jul 2007 17:04:07 +0200,
> Jesper Juhl wrote:
> >
> > Hi,
> >
> > This patch cleans up duplicate includes in
> >       XXXX/
>
> sound/ppc?  :)
>

Hehe, yup. Seems I forgot to edit my mail template for that one :)

> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> Now applied to ALSA tree.  Thanks.
>

Thanks a lot.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
