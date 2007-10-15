Return-Path: <linux-kernel-owner+w=401wt.eu-S1762497AbXJOQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497AbXJOQT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXJOQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:19:51 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:53680 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbXJOQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:19:50 -0400
Date: Mon, 15 Oct 2007 17:19:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Adrian Bunk <bunk@kernel.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: -git mips defconfig compile error
In-Reply-To: <20071015095535.GB9896@linux-mips.org>
Message-ID: <Pine.LNX.4.64N.0710151715200.16262@blysk.ds.pg.gda.pl>
References: <20071014131948.GF4211@stusta.de> <20071015095535.GB9896@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Ralf Baechle wrote:

> The logo.c bit I've sent out a few weeks ago so I'm just waiting for that
> patch to resurface at the other end of the wormhole.

 Hmm, I would have waited for this to happen before committing the change 
depending on it not to keep things known-broken then...  That's what I do 
with my bits, e.g. I have an update to platform code waiting till 
sb1250-mac.c changes come over here.

  Maciej
