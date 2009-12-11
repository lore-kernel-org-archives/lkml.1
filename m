Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZLKKCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZLKKCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZLKKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:02:25 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41656 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbZLKKCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nuCZUMHhPvyu/8sW9EfLHJGZ0c6kMDAzCB312o3xU2pRKfBR77S8CZW5Iayg2cagH+
         OHyPQTC3WXxUAI41xPj7W/jtHeY0Pce9/seSC0kUcyaDSg2PuBr9slcY2V7QnyXm0Pmd
         fsSfULSQy/VfK4E4kTCwtfiVO68jWki+CofqQ=
MIME-Version: 1.0
In-Reply-To: <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	 <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
	 <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
Date: Fri, 11 Dec 2009 11:02:30 +0100
Message-ID: <6a89f9d50912110202n702821c7u17f377f807cd0919@mail.gmail.com>
Subject: Re: [git pull] drm
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 00:58, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> But not only is Fedora not following the rules,
>
> You changed the rules. You require a Signed-off-by:. Fedora can no more
> add a signed off by than you can. It's not their code nor Red Hat's code
> any more than they "own" the kernel because they pay someone to work on
> it.
>
>> See above. It's not you. It's Fedora. If Fedora hadn't merged Nouveau and
>> shipped it, I wouldn't care.
>
> And zillions of Nvidia users would have been worse off.
>
> It's really simple: if you want to merge it *you* pull it and sign it off.
> If you aren't prepared to do that then ask why Fedora should, its not
> their code either.
>

So what, if someone outside RedHat is ok to sign it off, it can go
into staging? If it's that simple I don't mind signing it off
(including the dubious bits), I can take the blame if that helps
things move forward.

Stephane
