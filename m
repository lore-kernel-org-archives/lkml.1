Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYC1EXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYC1EXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYC1EW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:22:57 -0400
Received: from lixom.net ([66.141.50.11]:60931 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYC1EW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:22:56 -0400
Date: Thu, 27 Mar 2008 23:31:41 -0500
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fsldma: The MPC8377MDS board device tree node for
	fsldma driver
Message-ID: <20080328043141.GA24022@lixom.net>
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com> <1206517356-11209-2-git-send-email-wei.zhang@freescale.com> <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com> <9D668111-9774-4D45-944E-3C3C0EE47A09@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D668111-9774-4D45-944E-3C3C0EE47A09@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 09:23:54PM -0500, Kumar Gala wrote:

>> I think this patch should probably go through the powerpc tree, or
>> -mm.  I'll pick up the ones that touch either drivers/dma or
>> crypto/async_tx.

It's a good idea to cc all fsldma patches to linuxppc-dev when they're
posted too, none of them have been so they have been missing review from
the powerpc crowd that didn't catch them on lkml.


-Olof
