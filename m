Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZKTSCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZKTSCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZKTSCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:02:03 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:39559 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZKTSCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:02:02 -0500
MIME-Version: 1.0
In-Reply-To: <20091114001001.5343.99566.stgit@angua>
References: <20091114001001.5343.99566.stgit@angua>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 20 Nov 2009 11:01:40 -0700
X-Google-Sender-Auth: 23e2edec98a1aa48
Message-ID: <fa686aa40911201001m1ce0959dg21bcc2174653cd8a@mail.gmail.com>
Subject: Re: [RFC] MAINTAINERS: add SPI co-maintainer.
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?  Any comments on this?

If I don't hear anything, then I think I'm going to go ahead and push
out a tree with all the SPI changes I've signed off on and ask sfr to
add it to his list, just so that I'm sure that they get some
linux-next exposure before Linus opens the merge window.  I won't
necessarily ask LInus to pull it, I just want the testing.

Cheers.
g.

On Fri, Nov 13, 2009 at 5:25 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> Hi David, Andrew.
>
> David, I know that you haven't had enough time lately to keep on top
> of the pending SPI patches, so I was wondering if you would like some
> help?  If you are interested, I'm willing to act as co-maintainer of
> for the SPI subsystem.
>
> Here's what I'm thinking.  Right now all SPI patches are going through
> the -mm tree and just adding to akpm's burden.  I'd be more than happy
> to take over the task of actually collecting the acked patches into a
> git tree, getting them some exposure on linux-next, and asking Linus
> to pull it during the merge window.  If you ack them, then I'll merge
> them.
>
> I'm also be willing to take responsibility for all powerpc-specific
> SPI patches so that you don't need to look at them.
>
> How does this sound to you?
>
> Cheers,
> g.
>
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a1a2ace..2b697cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4937,6 +4937,7 @@ F:        drivers/char/specialix*
>
>  SPI SUBSYSTEM
>  M:     David Brownell <dbrownell@users.sourceforge.net>
> +M:     Grant Likely <grant.likely@secretlab.ca>
>  L:     spi-devel-general@lists.sourceforge.net
>  S:     Maintained
>  F:     Documentation/spi/
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
