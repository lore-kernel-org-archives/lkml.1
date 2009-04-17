Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbZDQOcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbZDQOcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbZDQOcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:32:15 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:56000 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304AbZDQOcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:32:15 -0400
Date: Fri, 17 Apr 2009 23:32:21 +0900 (JST)
Message-Id: <20090417.233221.07457681.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20904161823j2cce3a6fpea95ba79ccf871a3@mail.gmail.com>
References: <1239033288-3086-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20904161823j2cce3a6fpea95ba79ccf871a3@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 18:23:35 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 6, 2009 at 8:54 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > This patch adds support for the integrated DMAC of the TXx9 family.
> >
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > ---
> 
> Just so you know I have not forgotten about this...  I have pulled
> this version and integrated it into my cross-compile environment, so
> far so good.  I will try to get you an Acked-by by tomorrow.

Thanks!

> Ralf, I think I will leave the merge up to you.  As long as NET_DMA=n
> and ASYNC_TX_DMA=n the chance for a regression is low, but it's your
> call.

I believe there will be at least one more merge from mips tree before
2.6.30 ;)

---
Atsushi Nemoto
