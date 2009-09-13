Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZIMQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZIMQaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZIMQav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:30:51 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:50283 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbZIMQav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:30:51 -0400
Date: Mon, 14 Sep 2009 01:30:52 +0900 (JST)
Message-Id: <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com,
       linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Subject: Re: What's in async_tx.git/next for 2.6.32?
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4AA2BA83.5020707@intel.com>
References: <4AA2BA83.5020707@intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Sep 2009 12:22:43 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> Provided Neil and Peter provide their acks for the raid6 acceleration 
> work, here is what is pending in async_tx.git/next for 2.6.32:
...
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
> 
> Dan Williams (67):
...
>        dw_dmac: implement a private tx_list
>        fsldma: implement a private tx_list
>        iop-adma: implement a private tx_list
>        ioat: implement a private tx_list
>        mv_xor: implement a private tx_list
>        at_hdmac: implement a private tx_list
>        dmaengine: kill tx_list

Could you implement a private tx_list for txx9dmac too?

---
Atsushi Nemoto
