Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYHXRdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYHXRdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHXRd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:33:27 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:56084 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHXRd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:33:26 -0400
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, adobriyan@gmail.com
Subject: Re: Writable packet CD-RW mounting broken in 2.6.26 by your commit 68154e90c9d1492d570671ae181d9a8f8530da55
References: <20080808031437.GA14249@martell.zuzino.mipt.ru>
	<20080808053735.GA5274@martell.zuzino.mipt.ru>
	<8763pr1jy0.fsf_-_@hades.wkstn.nix>
	<20080824144827R.fujita.tomonori@lab.ntt.co.jp>
From: Nix <nix@esperi.org.uk>
Emacs: because editing your files should be a traumatic experience.
Date: Sun, 24 Aug 2008 18:33:06 +0100
In-Reply-To: <20080824144827R.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Sun, 24 Aug 2008 14:48:22 +0900")
Message-ID: <871w0eb9nx.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Aug 2008, FUJITA Tomonori spake thusly:
> I think that I put a bug in bio_copy_kern(). Can you try this patch?

It works, I can back up again!

> I think that bio_uncopy_user has the same bug. I'll send a patch after
> fixing this bug.

Great.

I suspect this is -stable material, right?
