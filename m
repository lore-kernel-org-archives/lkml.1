Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZAZKAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZAZKAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 05:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZAZKAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 05:00:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:60939 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301AbZAZKAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 05:00:33 -0500
Date: Mon, 26 Jan 2009 11:00:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nick Andrew <nick@nick-andrew.net>
cc: Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
Message-ID: <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Nick Andrew wrote:

> Fix more misspellings of "firmware" which I noticed in v2.6.29-rc2. All are
> comment changes.
> Nick.
> ---
> 
> Nick Andrew (20):
>       Fix misspelling of firmware in iwl-agn.c
>       Fix misspelling of firmware in iwl3945-base.c
>       Fix misspelling of firmware in hpmain.c
>       Fix misspelling of firmware in head_64.S
>       Fix misspelling of firmware in aica.c
>       Fix misspelling of firmware in pss.c
>       Fix misspelling of firmware in disk.c
>       Fix misspelling of firmware in libata.h
>       Fix misspelling of firmware in ChangeLog.history
>       Fix misspelling of firmware in ueagle-atm.c
>       Fix misspelling of firmware in pci.c
>       Fix misspelling of firmware in cmd.c
>       Fix misspelling of firmware in ipw2200.c
>       Fix misspelling of firmware in ipw2100.c
>       Fix misspelling of firmware in tg3.c
>       Fix misspelling of firmware in sb1250-mac.c
>       Fix misspelling of firmware in thinkpad_acpi.c
>       Fix misspelling of "firmware" in ip27-smp.c
>       Fix misspelling of "firmware" in firmware.txt
>       Fix misspelling of "firmware" in ia64-kvm.txt

I will fold all this into single patch and apply.

Thanks,

-- 
Jiri Kosina
SUSE Labs
