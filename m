Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXGEHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXGEHBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXGEHBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 03:01:41 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:38311 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbXGEHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 03:01:39 -0400
To: Karel Zak <kzak@redhat.com>
Cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <20070703221156.GY14825@petra.dvoda.cz>
	<20070704174753.GC1939@DervishD>
From: Nix <nix@esperi.org.uk>
Emacs: anything free is worth what you paid for it.
Date: Thu, 05 Jul 2007 08:01:27 +0100
In-Reply-To: <20070704174753.GC1939@DervishD> (DervishD's message of "Wed, 4 Jul 2007 19:47:53 +0200")
Message-ID: <87sl83fi60.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Jul 2007, DervishD stated:
>     Anyway, if you don't like mobs or you just don't want to try it,
> that's fine, but please don't use autotools, it doesn't make much sense
> for a linux only project, since you will be using only the "directory
> choosing" part of autotools. Maybe a hand made script will help (and I

Oh, yeah, great, another hand-rolled build system. That's *juwt* what
those of us who have autotools working well (with config.site's that
do all we need and then some) are looking forward to.

There are advantages to standardization, you know. A *lot* of
autobuilders know how to make autoconf-generated configure scripts jump
through hoops. I was downright *happy* when util-linux was
autoconfiscated: I could ditch the code to handle automatic
configuration of yet another one-package hand-rolled build system.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
