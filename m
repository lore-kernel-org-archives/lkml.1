Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZLIOiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZLIOiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZLIOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:38:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZLIOiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:38:14 -0500
Date: Wed, 9 Dec 2009 15:38:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the tty tree with the trivial tree
In-Reply-To: <20091209162826.a28c6c68.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0912091536230.3755@pobox.suse.cz>
References: <20091209162826.a28c6c68.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Stephen Rothwell wrote:

> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in 
> drivers/mmc/card/sdio_uart.c between commit 
> 1e04b7ae709d19d5c9f69c64e1e30253018ce102 ("sdio_uart: coding style 
> fixes") from the trivial tree and various commits from the tty tree.
> 
> I just used the tty tree version where they clashed.  Jiri, you might
> consider sending that patch to Greg for the tty tree.

Hi,

the trivial tree pull request has already been sent to Linus a day ago. I 
am now waiting whether it will be merged or missed.

In the latter case, I will split the tty hunk out and send to Greg. In the 
former case the conflict would have to be solved either by Greg or Linus.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
