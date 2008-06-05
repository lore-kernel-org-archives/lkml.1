Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYFEOpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYFEOpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFEOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:45:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46425 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYFEOpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:45:19 -0400
Date: Thu, 5 Jun 2008 16:45:11 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: fix G5 SATA broken on -rc5
Message-ID: <20080605144511.GA6562@aepfle.de>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605112436.GA4533@aepfle.de> <Pine.LNX.4.64.0806051255340.28792@blonde.site> <20080605135444.7a1e5158@core> <Pine.LNX.4.64.0806051436180.5315@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806051436180.5315@blonde.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, Hugh Dickins wrote:

> Fix G5 SATA irq 18: nobody cared, reported on -rc5 by Olaf Hering:
> fixlet to a57c1bade5a0ee5cd8b74502db9cbebb7f5780b2 libata-sff:
> Fix oops reported in kerneloops.org for pnp devices with no ctl
>     
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>


Tested-by: Olaf Hering <olaf@aepfle.de>

