Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbXBEJsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbXBEJsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXBEJsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:48:30 -0500
Received: from ns1.suse.de ([195.135.220.2]:37106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXBEJs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:48:29 -0500
To: vgoyal@in.ibm.com
Cc: Alon Bar-Lev <alon.barlev@gmail.com>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 -- Loads of section mismatches
References: <a44ae5cd0702041402g14051b58qfeb270a72123e22e@mail.gmail.com>
	<9e0cf0bf0702041406n50bd5639l66b62647d9c4795e@mail.gmail.com>
	<20070205064029.GA23996@in.ibm.com>
From: Andi Kleen <ak@suse.de>
Date: 05 Feb 2007 11:48:57 +0100
In-Reply-To: <20070205064029.GA23996@in.ibm.com>
Message-ID: <p73sldknali.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-move-startup_32-in-texthead-section.patch
> 
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/x86_64-mm-break-init-in-two-parts-to-avoid-modpost-warnings.patch

The two part init / head.S patch was considered too intrusive late
in the game.
Near all of the other section patches should have made it in though.

-Andi
