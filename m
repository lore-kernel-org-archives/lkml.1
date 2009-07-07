Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbZGGIEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbZGGIEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZGGIEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:04:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:49543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZGGIES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:04:18 -0400
Date: Tue, 7 Jul 2009 10:04:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Trivial: Fix typo "for for" in multiple files
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11157@dbde02.ent.ti.com>
Message-ID: <alpine.LNX.2.00.0907071003150.4994@wotan.suse.de>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11157@dbde02.ent.ti.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Gadiyar, Anand wrote:

> From: Anand Gadiyar <gadiyar@ti.com>
> 
> Trivial: Fix typo "for for" in multiple files.
> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> ---
> After submitting a patch [1] for two instances of this in EHCI code,
> I decided to grep the rest of the kernel as well and came up with this.
> 
> Let me know if you want me to re-submit with both patches folded
> together.

Yes, I will prefer that, I would otherwise merge the patches together 
anyway, thanks.

While at it, could you please also respin your patch on top of current 
Linus' tree, it doesn't apply cleanly in the form you have submitted.

Thanks,

-- 
Jiri Kosina
SUSE Labs
