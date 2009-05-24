Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZEXE6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZEXE6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 00:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZEXE6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 00:58:44 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1535 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZEXE6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 00:58:43 -0400
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
 linux-kernel@vger.kernel.org  from all but "THE REST"
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
References: <cover.1243131992.git.joe@perches.com>
	 <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
	 <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com>
	 <1243135358.3560.1.camel@Joe-Laptop.home>
	 <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
	 <1243139947.3560.7.camel@Joe-Laptop.home>
	 <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 May 2009 21:58:01 -0700
Message-Id: <1243141081.3560.11.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 22:51 -0600, Grant Likely wrote:
> Do subsystem maintainers think so?  Unless they do (and tell others
> so), I don't think it will actually happen.  Until that point, I don't
> think the L:linux-kernel lines should be removed.

Well, if scripts/get_maintainers.pl becomes more widely used,
cc'ing lkml will become more automatic.

Anyway, removing lkml from all sections might stop
a MAINTAINERS reader from thinking lkml should not
be cc'd when not mentioned.

cheers, Joe

