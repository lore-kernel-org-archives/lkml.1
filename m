Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYKWXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYKWXa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYKWXaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:30:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53375 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYKWXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:30:16 -0500
Date: Sun, 23 Nov 2008 23:30:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081123233007.GA3959@srcf.ucam.org>
References: <20081014025453.617f2ef8@werewolf.home> <20081014174536.1353d17e@mjolnir.drzeus.cx> <20081014232759.08f5d212@werewolf.home> <20081123213921.667ecb93@mjolnir.drzeus.cx> <4929D803.80708@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4929D803.80708@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 10:24:03PM +0000, Alan Jenkins wrote:

> Matthew, if I have confused two similar issues, could you please help by 
> explaining the differences?

You're correct. On any released version of Linux, the Aspire One's SD 
slot will only show up if a card was inserted when the machine was 
booted. That's how it's always been. I have code to fix it, which will 
land in the 2.6.29 timeframe with luck.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
