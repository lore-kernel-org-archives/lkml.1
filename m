Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbXHAKMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbXHAKMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:12:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761175AbXHAKLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:11:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:50840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760028AbXHAKLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:11:53 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Haifeng He" <hehaifeng2nd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Load interrupt code dynamically
References: <ab08258e0707311426r32dc15cexb6867648bc6a45a4@mail.gmail.com>
	<20070801010304.757f4963@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 13:06:27 +0200
In-Reply-To: <20070801010304.757f4963@the-village.bc.nu>
Message-ID: <p73ejinpl8s.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> Realistically - the one case it is done right now is by the mainframe
> people, simply because the underlying hypervisor does it. You probably
> have much more chance that way using a microkernel (real one not MACH)
> underneath. Still a huge task.

There are also patchkits for KVM for swappable guests. And you can do it today 
in qemu.

-Andi
