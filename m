Return-Path: <linux-kernel-owner+w=401wt.eu-S937460AbXFGWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937460AbXFGWqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763911AbXFGWq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:46:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:49928 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935230AbXFGWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E572VGhkC6g52M7FzPz2cg7IXezX/Gm0M3o5YnX23sV50Z1Cu+wjzlSA1K5pICID3iwK+4BR89Rg8h8fl8IH2ROLu5flhxes04mgT+KFQvkOpZCcU5248p5a9jp7csO/JjoQRXEcXSJv6KQol3IkMnM38+ZIk5pZ+1ZDy/S5wzc=
Message-ID: <9a8748490706071546k1f34a39s92102f7345ba4192@mail.gmail.com>
Date: Fri, 8 Jun 2007 00:46:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
In-Reply-To: <200706071832.13486.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070607162251.5f291325@the-village.bc.nu>
	 <m3wsyfzcpt.fsf@maximus.localdomain>
	 <200706071832.13486.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Thursday 07 June 2007 17:17:18 Krzysztof Halasa wrote:
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > > The intel-rng printed a nice well formatted message when the port was
> > > disabled. Someone then came along and blindly trashed it by screwing up a
> > > trim down to 80 columns.
> >
> > Perhaps we should drop that 80-column style and use some 120+?
> > X or no X, almost all people now have more lines and columns on their
> > displays than MDA 20 years ago.
> >
> > 132 to match text VGA perhaps?
> > 80 can be left for the actual _output_, I mean number of chars printed
> > by kernel code.
>
> Why? My consoles are *all* still 80x24 text mode. It's only if I decide to
> monkey with the settings (and why fix what isn't broken?) or when I'm in X
> that I get a bigger screen than that.
>
> I think the general consensus on the 80 character lines isn't for the average
> home user, but for the people that have things like old Wyse terminals and
> such hooked up.
>

Hmm, perhaps my eyes are just not as good as other peoples, but my X
runs at 1600x1200 and I have konsole in KDE configured so that when it
is maximized it is very close to a 80x25 window (actually it is 82x31
with a size 18 font).
Nice and readable, if I make the font any smaller to fit more
cols/rows then the text gets too small and my eyes hurt.
Reading kernel code formatted for 80cols fits perfectly for me.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
