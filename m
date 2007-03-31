Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXCaKgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXCaKgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 06:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXCaKgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 06:36:55 -0400
Received: from ns1.suse.de ([195.135.220.2]:50447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXCaKgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 06:36:54 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: updated list of "dead" Makefile CONFIG_ variables
References: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
X-Yow: I've got to get these SNACK CAKES to NEWARK by DAWN!!
Date: Sat, 31 Mar 2007 12:36:53 +0200
In-Reply-To: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
	(Robert P. J. Day's message of "Sat, 31 Mar 2007 06:12:01 -0400
	(EDT)")
Message-ID: <je1wj51yyi.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> ===== MACHINE =====
> ./arch/ppc/boot/simple/Makefile:# zimage-$(CONFIG_MACHINE) and zimagerd-$(CONFIG_MACHINE) to the target
> ./arch/ppc/boot/simple/Makefile:# that produces the desired image and they must set end-$(CONFIG_MACHINE)
> ./arch/ppc/boot/simple/Makefile:# than 'zImage.elf', set end-$(CONFIG_MACHINE) to be the suffix used for
> ./arch/ppc/boot/simple/Makefile:# set entrypoint-$(CONFIG_MACHINE) to the location which the image should be
> ./arch/ppc/boot/simple/Makefile:# loaded at.  The optimal setting for entrypoint-$(CONFIG_MACHINE) is the link
> ./arch/ppc/boot/simple/Makefile:# misc-$(CONFIG_MACHINE) variable.

That looks like a meta variable.  It's only a comment anyway.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
