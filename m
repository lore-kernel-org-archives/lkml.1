Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbXE3TxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbXE3TxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXE3TxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:53:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:50505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077AbXE3TxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:53:13 -0400
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH motherboards.
References: <Pine.LNX.4.64.0705291905300.4689@p34.internal.lan>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 May 2007 22:49:49 +0200
In-Reply-To: <Pine.LNX.4.64.0705291905300.4689@p34.internal.lan>
Message-ID: <p73iraadok2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> When I use 8GB of memory on my x86_64 system, CPU-bound processes are VERY
> slow, up to 36x slower than usual. 

Likely a BIOS problem; e.g. misconfigured MTRRs. Complain to your motherboard
vendor.

-Andi
