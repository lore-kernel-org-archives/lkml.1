Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758209AbYLPXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYLPXW7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYLPXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:22:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:42131 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYLPXWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:22:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xyAf9geTq4drJlq3HAjn/XD1nBggg0mp5c05Z8r0TaoxlPErc0aKcerGUSALgg/sm3
         IYQgNsjecLetkq0QOiUvPiZGerjggUmVyhXRESeEOwLAaO1SHeJPo9EdAlwWQfNPkKmM
         2DsdIrbG054N+aj/nyBqcVDuzogJTvxoyZV8M=
Message-ID: <b647ffbd0812161522t361cfbf5x80fd836ad99607f6@mail.gmail.com>
Date: Wed, 17 Dec 2008 00:22:45 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 0/10] x86: microcode_amd: fixes and cleanup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20081216180639.GG7013@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216180639.GG7013@alberich.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

>
> Following a small series of patches to cleanup microcode_amd. Patch 1
> might be of interest for .28. But I don't know whether you are willing to
> apply the whole series for .28.
>

I wonder if you see a problem with the scenario described here
http://bugzilla.kernel.org/process_bug.cgi
on any of your systems?

Thanks in advance,


>
> Thanks,
>
> Andreas
>

-- 
Best regards,
Dmitry Adamushko
