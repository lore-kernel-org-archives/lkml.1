Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbXHXTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbXHXTcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXHXTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:32:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:37400 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbXHXTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fWcn6f8uT/bzErpL7m3RidYeD4J4pU0x+qyx7lywYlVc7dkzsSKmgUzp8hfxmlSlCh1FOaUFq1OnuZnC4bTk9DFCjbiFEQDIoGx/tQge7KDhNPL52Q4iYNIn9bsY7SdGRt8uTUifor004WTUsWOoStp1lcLs3UlvbEARhsShv0E=
Message-ID: <40f323d00708241232t1ea6a05fkebb1dbf67fbe69e9@mail.gmail.com>
Date: Fri, 24 Aug 2007 21:32:10 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Udo van den Heuvel" <udovdh@xs4all.nl>
Subject: Re: possible BUG while doing gpg --gen-key
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CF1DDE.7070302@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF079C.7010304@xs4all.nl>
	 <40f323d00708241057k6549f22fl6abf802f14c03e44@mail.gmail.com>
	 <46CF1DDE.7070302@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> Benoit Boissinot wrote:
> > On 8/24/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> >> While doing gpg --gen-key I can reproduce quite well some sort of
> >> crash/bug/etc:
> >> # gpg --gen-key
> >
> > [snip]
> >
> > iirg gpg-keygen uses a lot of cpu time during that phase, you probably
> > should verify your ram and cpu. This kind of problem is often due to
> > faulty hardware.
>
> The box runs stable for days on end.
> Only when running gpg --gen-key I get this issue.
> Other gpg operations, run by a user, are without issue.
> There is 512MB of RAM and the hardware is `refreshed` regularly when an
> interesting VIA board comes out. Case stays closed otherwise. I am ESD
> certified. (or how to put that in the english language)
> memtest86 shows no problems. Kernel compiles etc run without issue.
> F7 upgraded installation. Updated regularly. gnupg rpm is Red Hat-stock.
>  My own compiles of gnupg show the same error.
>
> So what is next?
>
Sorry, I'll let the gurus speak then ;)

regards,

Benoit
