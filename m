Return-Path: <linux-kernel-owner+w=401wt.eu-S1762617AbYENP1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617AbYENP1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYENP1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:27:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYENP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:27:36 -0400
From: Andreas Schwab <schwab@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to `strlen'
References: <Pine.LNX.4.64.0805140958400.5778@anakin>
	<jeprrpth5m.fsf@sykes.suse.de>
	<20080514141056.GB19909@cs181133002.pp.htv.fi>
	<jeabitt0xj.fsf@sykes.suse.de> <20080514144031.GA6902@cvg>
	<je63thszo6.fsf@sykes.suse.de> <20080514151407.GD6902@cvg>
X-Yow: I'm also against BODY-SURFING!!
Date: Wed, 14 May 2008 17:27:35 +0200
In-Reply-To: <20080514151407.GD6902@cvg> (Cyrill Gorcunov's message of "Wed,
	14 May 2008 19:14:07 +0400")
Message-ID: <je1w44ucrc.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> Andreas, could you test/review the following patch
> (what is worse - I *have* introduced buffer overflow with my
> patch, so I think we should fix it asap)

I've compiled the file with the various cross compilers I have laying
around here, no reference to strlen any more.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
