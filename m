Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZERGdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZERGdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZERGdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:33:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60379 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZERGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NwIoUriW1xbyenGg4sTuuLt+g7Xu21ASeGJq1zxWjqzkgROY7zA99GJLcD5NUyvEcp
         YlP99RIKpfT58ZDf6PxdG2Ry4XS//gdZwJy3auhBgvIqDJyj56XJoxHEFt05L1gQ+Teb
         x8gbimIHDR1f6qEJpvPrf09w3R4WcFFWZrB/8=
Date: Mon, 18 May 2009 08:32:58 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>,
       linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090518063258.GB7818@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org,
	Martin Lottermoser <Martin.Lottermoser@t-online.de>,
	linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <200905172218.01606.bzolnier@gmail.com> <20090517203033.GB5142@liondog.tnic> <200905180048.36483.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200905180048.36483.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 18, 2009 at 12:48:36AM +0200, Bartlomiej Zolnierkiewicz wrote:

[..]

> > have a hunch - and you did. Besides, it's not like I'm waiting for you
> > - I have other things on my plate which I could tackle while you handle
> > the case you're more knowledgeable at. It is simple as that.
> 
> That is missing the point -- we are not the only knowledgeable ones here
> and we definitely want to encourage other people to attack the problems.
> 
> [ Please read my mail again.  I explicitly said "people" not "you" there. ]

I was being a realist - nobody but you, Sergei and me does attack
problems. But there's always the hope :).

> 
> > But I'll start CCing linux-ide if that's your preference.
> 
> Thanks but my preferences are not the point here.  That is just the most
> efficient way for everybody: IDE/ATA problems should be handled at linux-ide
> mailing list.  You can still cc: me but cc:ing linux-ide takes priority.

Yep, got it.

-- 
Regards/Gruss,
    Boris.
