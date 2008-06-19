Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYFSPD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYFSPD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFSPDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:03:20 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:50741 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYFSPDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:03:20 -0400
Date: Fri, 20 Jun 2008 00:04:47 +0900 (JST)
Message-Id: <20080620.000447.05598315.anemo@mba.ocn.ne.jp>
To: greg@kroah.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] jedec_probe: Fix SST 16-bit chip detection
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080619110418.GB27196@kroah.com>
References: <20080619.163648.262833678.nemoto@toshiba-tops.co.jp>
	<20080619110418.GB27196@kroah.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 04:04:18 -0700, Greg KH <greg@kroah.com> wrote:
> In the future, if you want something to go into the stable tree, just
> add:
> 	cc: stable <stable@kernel.org>
> to the signed-off-by area of the patch and we will be automatically
> notifed when it goes into Linus's tree and will then add it to the
> -stable tree.
> 
> Otherwise it's a pain to try to track when a patch goes into mainline.

Sure.  Will do next time.  I had misunderstand the statement in
stable_kernel_rules.txt, as CC: in mail header (not S-O-B area) is
enough.  Thank you.

> Can you notify us when this patch is accepted?

Sure too.
---
Atsushi Nemoto
