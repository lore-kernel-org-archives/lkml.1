Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXAWGPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXAWGPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933061AbXAWGPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:15:20 -0500
Received: from main.gmane.org ([80.91.229.2]:57378 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053AbXAWGPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:15:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [updated PATCH] remove 555 unneeded #includes of sched.h
Date: Tue, 23 Jan 2007 06:15:02 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerbafa.e7s.olecom@flower.upol.cz>
References: <Pine.LNX.4.63.0612282059160.8356@gockel.physik3.uni-rostock.de> <20061228124644.4e1ed32b.akpm@osdl.org> <Pine.LNX.4.63.0612282154460.20531@gockel.physik3.uni-rostock.de> <20061228210803.GR17561@ftp.linux.org.uk> <Pine.LNX.4.63.0612282211330.20531@gockel.physik3.uni-rostock.de> <20061228213438.GD20596@flint.arm.linux.org.uk> <Pine.LNX.4.63.0612282239190.20531@gockel.physik3.uni-rostock.de> <Pine.LNX.4.63.0612291115160.5654@gockel.physik3.uni-rostock.de>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2006-12-29, Tim Schmielau wrote:
[]
> OK, building 2.6.20-rc2-mm1 with all 59 configs from arch/arm/configs 
> with and w/o the patch indeed found one mysterious #include that may not 
> be removed. Thanks, Russell!
>
> Andrew, please use the attached patch instead of the previous one, it also 
> has a slightly better patch description.

Great job!

About patch. To make it smaller, i think, you better use less
"unified context" lines `diff -u1'.

Nice done! 
____

