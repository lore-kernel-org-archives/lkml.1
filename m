Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYJTHpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYJTHpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYJTHpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:45:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:35549 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548AbYJTHpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:45:40 -0400
Date: Mon, 20 Oct 2008 09:45:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Remove rogue default ms for THRUSTMASTER/ZEROPLUS in
 drivers/hid/Kconfig
In-Reply-To: <20081020062015.GD12825@one.firstfloor.org>
Message-ID: <alpine.LNX.1.10.0810200945210.27479@jikos.suse.cz>
References: <1224398310-10676-1-git-send-email-andi@firstfloor.org> <alpine.LNX.1.10.0810192035380.27479@jikos.suse.cz> <20081020062015.GD12825@one.firstfloor.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Andi Kleen wrote:

> > > No reason at all to make these obscure drivers default m
> > Agreed and applied, thanks.
> Can you please merge them still for 2.6.28? It would be sad if lots 
> of .configs got these.

Yes, it is in the 2.6.28 queue.

-- 
Jiri Kosina
SUSE Labs
