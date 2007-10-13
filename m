Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXJMBKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXJMBKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXJMBKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:10:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbXJMBKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:10:35 -0400
Date: Fri, 12 Oct 2007 18:10:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: rdreier@cisco.com, torvalds@linux-foundation.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
Message-Id: <20071012181019.3bb138cd.akpm@linux-foundation.org>
In-Reply-To: <20071011.181719.78707713.davem@davemloft.net>
References: <aday7e9b0m3.fsf@cisco.com>
	<20071011.181719.78707713.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 18:17:19 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Roland Dreier <rdreier@cisco.com>
> Date: Thu, 11 Oct 2007 18:08:52 -0700
> 
> > This will get the batch of changes queued up for the 2.6.24 merge
> > window (although I still have a few more things to merge later, once
> > Dave Miller's networking tree has landed too):
> 
> Roland are you absolutely sure this won't create merge conflicts with
> my 8MB net-2.6 merge, inside of which there are many infiniband
> driver changes?

I'd have told him if there were any such problems.

There might of course be runtime problems, but I'm sure the infiniband
developers are testing -mm kernels so that any such problems will be
picked up beforehand (heh, I kill me).

