Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbZEEFQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbZEEFQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZEEFQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:16:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:4718 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZEEFQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:16:45 -0400
MIME-Version: 1.0
In-Reply-To: <1241499317.10504.59.camel@pasglop>
References: <1241499317.10504.59.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 4 May 2009 23:16:29 -0600
Message-ID: <fa686aa40905042216n4d12fba7y21704fba1a201f59@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ben,

Can you please also pull in my merge branch?

http://ozlabs.org/pipermail/linuxppc-dev/2009-May/071626.html

Thanks,
g.

On Mon, May 4, 2009 at 10:55 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Hi Linus !
>
> Here are a few things still for .30 for you to merge !
>
> Cheers,
> Ben.
>
> The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
>  Linus Torvalds (1):
>        Linux 2.6.30-rc4
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
>
> Benjamin Herrenschmidt (1):
>      powerpc: Fix setting of oprofile cpu type
>
> Grant Likely (1):
>      powerpc: Update MPC5xxx and Xilinx Virtex maintainer entries
>
> Michael Wolf (1):
>      powerpc adjust oprofile_cpu_type version 3
>
>  MAINTAINERS                    |    4 ++--
>  arch/powerpc/kernel/cputable.c |   15 ++++++++++-----
>  2 files changed, 12 insertions(+), 7 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
