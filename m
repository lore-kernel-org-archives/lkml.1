Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXICMxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXICMxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbXICMwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:52:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbXICMww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:52:52 -0400
Date: Mon, 3 Sep 2007 05:51:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, lists4me@web.de,
       adaplas@gmail.com, hpa@zytor.com, lenb@kernel.org, dth@dth.net,
       linux-fsdevel@vger.kernel.org, nfs@lists.sourceforge.net,
       Trond.Myklebust@netapp.com, andrew@digital-domain.net,
       peter.kovar@gmail.com
Subject: Re: [2/4] 2.6.23-rc5: known regressions
Message-Id: <20070903055114.7f82ef46.akpm@linux-foundation.org>
In-Reply-To: <b6a2187b0709030536w3e40f12bk4d25b6eb954d22b6@mail.gmail.com>
References: <46DBD982.3080102@googlemail.com>
	<46DBDD8B.7040706@googlemail.com>
	<b6a2187b0709030536w3e40f12bk4d25b6eb954d22b6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 3 Sep 2007 20:36:32 +0800 "Jeff Chua" <jeff.chua.linux@gmail.com> wrote:
> On 9/3/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
> > Subject         : console is messed up after resume from s2ram or switching to console from X
> > References      : http://lkml.org/lkml/2007/8/4/6
> > Last known good : ?
> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> > Caused-By       : ?
> > Handled-By      : H. Peter Anvin <hpa@zytor.com>
> >                   Antonino A. Daplas <adaplas@gmail.com>
> > Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
> > Status          : problem is being debugged
> 
> Michal,
> 
> Can you please close this case. I'm using the workaround and satisfied with it.
> 

2.6.21 was OK, and 2.6.23-rc2 needed a manual workaround?

That's a regression.
