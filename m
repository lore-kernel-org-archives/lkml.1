Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZIOQM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZIOQM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZIOQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:12:53 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:52470 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZIOQMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:12:53 -0400
Date: Wed, 16 Sep 2009 01:12:55 +0900 (JST)
Message-Id: <20090916.011255.179957018.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com,
       linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Subject: Re: What's in async_tx.git/next for 2.6.32?
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4AAD28F2.3040606@intel.com>
References: <4AA2BA83.5020707@intel.com>
	<20090914.013052.84972601.anemo@mba.ocn.ne.jp>
	<4AAD28F2.3040606@intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Sep 2009 10:16:34 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Could you implement a private tx_list for txx9dmac too?
> 
> I noticed that too when I merged with -next.  I forgot to send this [1] out.

Thanks, looks OK for me.

---
Atsushi Nemoto
