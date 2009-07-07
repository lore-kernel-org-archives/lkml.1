Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZGGKD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZGGKD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZGGKDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:03:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53199 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZGGKDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:03:20 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jul 2009 15:33:12 +0530
Subject: RE: [PATCH] Trivial: Fix typo "for for" in multiple files
Thread-Topic: [PATCH] Trivial: Fix typo "for for" in multiple files
Thread-Index: Acn+2Y/W7XDcdmJyQ4ud8YexWw3b9wAECpSQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11466@dbde02.ent.ti.com>
In-Reply-To: <alpine.LNX.2.00.0907071003150.4994@wotan.suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Jiri Kosina wrote: 
> On Mon, 6 Jul 2009, Gadiyar, Anand wrote:
> 
> > From: Anand Gadiyar <gadiyar@ti.com>
> > 
> > Trivial: Fix typo "for for" in multiple files.
> > 
> > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > ---
> > After submitting a patch [1] for two instances of this in EHCI code,
> > I decided to grep the rest of the kernel as well and came up with this.
> > 
> > Let me know if you want me to re-submit with both patches folded
> > together.
> 
> Yes, I will prefer that, I would otherwise merge the patches together 
> anyway, thanks.
> 
> While at it, could you please also respin your patch on top of current 
> Linus' tree, it doesn't apply cleanly in the form you have submitted.
> 

Oops, sorry. I was on an old kernel tree.

Regenerated against current mainline git, and folded both the patches.
I have submitted a fresh patch for this, so please discard patch 1. And
another one for a similar typo "to to".

Thanks,
Anand
