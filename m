Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbYBXQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbYBXQ7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYBXQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:59:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYBXQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:59:35 -0500
From: Andreas Schwab <schwab@suse.de>
To: petkovbb@gmail.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
	<20080218.135827.74754725.k-ueda@ct.jp.nec.com>
	<jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic>
X-Yow: I'm in LOVE with DON KNOTTS!!
Date: Sun, 24 Feb 2008 17:59:26 +0100
In-Reply-To: <20080224163244.GA11998@gollum.tnic> (Borislav Petkov's message
	of "Sun\, 24 Feb 2008 17\:32\:44 +0100")
Message-ID: <jehcfyffyp.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <petkovbb@googlemail.com> writes:

> burning a dvd here with growisofs works just fine.

You probably don't have a Pioneer.

> However, my strace -v won't dereference the struct pointer passed to
> the ioctl:

I use strace 4.5.16.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
