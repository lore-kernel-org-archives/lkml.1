Return-Path: <linux-kernel-owner+w=401wt.eu-S1422784AbXBUSeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422784AbXBUSeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422783AbXBUSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:34:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:40303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422784AbXBUSeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:34:11 -0500
From: Andreas Schwab <schwab@suse.de>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc1
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
X-Yow: I'm changing the CHANNEL..  But all I get is commercials
 for ``RONCO MIRACLE BAMBOO STEAMERS''!
Date: Wed, 21 Feb 2007 19:34:01 +0100
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 20 Feb 2007 20:53:45 -0800 (PST)")
Message-ID: <jeejojmkbq.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting an undefined symbol with CONFIG_AGP=m:

WARNING: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
