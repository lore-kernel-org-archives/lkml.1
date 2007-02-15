Return-Path: <linux-kernel-owner+w=401wt.eu-S1422736AbXBOXvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736AbXBOXvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422734AbXBOXvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:51:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422693AbXBOXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:51:43 -0500
Date: Thu, 15 Feb 2007 15:51:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] libata updates (mostly fixes)
In-Reply-To: <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702151550380.20368@woody.linux-foundation.org>
References: <20070215233411.GA10782@havoc.gtf.org>
 <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Linus Torvalds wrote:
> 
> Ok, this is just _strange_.

Btw, I did pull, but I still think we shouldn't do those kinds of strange 
Kconfig file games.

		Linus
