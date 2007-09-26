Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXIZP25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXIZP25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760952AbXIZP2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:28:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33289 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760885AbXIZP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:28:33 -0400
Date: Wed, 26 Sep 2007 11:28:13 -0400
Message-Id: <200709261528.l8QFSDdF028533@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 03/25] Unionfs: display informational messages only if debug is on 
In-reply-to: Your message of "Wed, 26 Sep 2007 17:24:08 +0200."
             <Pine.LNX.4.64.0709261720330.7066@fbirervta.pbzchgretzou.qr> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0709261720330.7066@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
[...]
> Surprise, pr_debug() is just that all nicely wrapped up.
> Want debug? Do it like this.
> 
> #ifdef CONFIG_UNIONFS_DEBUG
> #	define DEBUG 1
> #endif
> 
> and pr_debug() works magic.
[...]

Sounds good.  I'll do that.

Thanks,
Erez.
