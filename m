Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYJMVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYJMVOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYJMVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:14:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbYJMVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:14:40 -0400
Date: Mon, 13 Oct 2008 14:14:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCMCIA updates and fixes for 2.6.28
In-Reply-To: <20081013173803.GA18569@comet.dominikbrodowski.net>
Message-ID: <alpine.LFD.2.00.0810131413170.3288@nehalem.linux-foundation.org>
References: <20081013173803.GA18569@comet.dominikbrodowski.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Dominik Brodowski wrote:
> 
> There's a small merge conflict due to Alan's bugfix to drivers/pcmcia/ds.c.
> Could you either fix this up or explain me how to prepare the merge for you?

I fixed it up, thanks,

		Linus
