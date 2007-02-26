Return-Path: <linux-kernel-owner+w=401wt.eu-S1161023AbXBZUlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023AbXBZUlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXBZUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:41:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33005 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbXBZUlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:41:01 -0500
Date: Mon, 26 Feb 2007 12:41:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] CREDITS: update my email address
In-Reply-To: <200702251149.l1PBn1NS003247@harpo.it.uu.se>
Message-ID: <Pine.LNX.4.64.0702261236470.12485@woody.linux-foundation.org>
References: <200702251149.l1PBn1NS003247@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Feb 2007, Mikael Pettersson wrote:
> 
> Should CREDITS have a specific maintainer?

We used to have one for the CREDITS (I think jam - John A Martin) file but 
the maintenance overhead is so small that having a maintainer for it ends 
up being more of a hassle than just not having one at all, and doing it on 
a case-by-case basis.

If somebody who maintains some other thing _anyway_ were to keep track of 
the MAINTAINERS file (the trivial people comes to mind), that might be 
worth it, but in general I suspect it's not a big deal.

		Linus
