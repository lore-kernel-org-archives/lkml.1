Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYHFMXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYHFMXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYHFMVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:21:22 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54365 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbYHFMVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:21:20 -0400
Date: Wed, 6 Aug 2008 14:21:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
In-Reply-To: <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808061417540.20424@pc-004.diku.dk>
References: <20080806105836.GA2903@localhost.localdomain> 
 <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com> 
 <19f34abd0808060428m1c317531v4a58679c4051c0e9@mail.gmail.com>
 <8bd0f97a0808060514x5c9ed37exbf8f9852b5a0b55d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *shrug* ... i dont see other patches with things like:
> The patch was generated with git.
> The patch was generated with eclipse.
> The patch was generated with emacs.
> etc...
> 
> we dont generally list all of the tools in the log message that was
> used in *creating* a patch since it doesnt really add any value when
> looking back historically at changes.

But with git, emacs, eclipse etc, the person is still making the change by 
hand.  The comment is more like "this patch was generated with perl" or 
"this patch was generated with sed", indicating that the change is 
uniform enough to be automated.  This does have some interest, 
although perhaps not for everyone.

julia
