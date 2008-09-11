Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYIKRuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYIKRuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYIKRuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 13:50:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbYIKRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 13:50:12 -0400
Date: Thu, 11 Sep 2008 10:49:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
In-Reply-To: <200809111832.38051.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809111048340.3384@nehalem.linux-foundation.org>
References: <48C68507.6000609@suse.com> <200809111749.40204.elendil@planet.nl> <alpine.LFD.1.10.0809110852460.3384@nehalem.linux-foundation.org> <200809111832.38051.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Sep 2008, Frans Pop wrote:
> >
> > Aren't _you_ the one who are ignoring current issues?
> 
> I don't think so.
> _The_ current issue for me is that I can no longer build Debian kernel 
> packages using 'make deb-pkg', which is part of _your_ tree, and install 
> the resulting package *NOW*.

Well, complain to the right people then. The patch that started this all 
is wrong. The people you are complaining to are not the rigth people. We 
can't do anything about debian packaging.

		Linus
