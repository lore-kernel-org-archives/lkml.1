Return-Path: <linux-kernel-owner+w=401wt.eu-S1031491AbXD3J3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031491AbXD3J3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031493AbXD3J3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:29:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:39703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031491AbXD3J3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:29:13 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
References: <20070428191927.GN3468@stusta.de>
	<1177795118.7828.6.camel@localhost>
	<20070430035838.GC77450368@melbourne.sgi.com>
	<20070430091754.24df88df@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Apr 2007 12:26:42 +0200
In-Reply-To: <20070430091754.24df88df@the-village.bc.nu>
Message-ID: <p73wszuyx7h.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> If this still occurs for some
> combinations then the fix would be 8K + 4K IRQ stack, not just to use 8K
> stack

Yes i've been thinking for some time doing that would be a good idea.

-Andi
