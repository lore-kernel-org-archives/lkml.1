Return-Path: <linux-kernel-owner+w=401wt.eu-S935755AbYBMWJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755AbYBMWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935570AbYBMWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:08:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37384 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935412AbYBMWIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:08:20 -0500
Date: Wed, 13 Feb 2008 22:00:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: jejb@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove ps2esdi
Message-ID: <20080213220038.33e3770f@core>
In-Reply-To: <20080213213122.GZ3383@cs181133002.pp.htv.fi>
References: <20080213213122.GZ3383@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 23:31:22 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> The ps2esdi driver was marked as BROKEN more than two years ago due
> to being no longer working for some time.
> 
> A drivers that had been marked as BROKEN for such a long time seems to
> be unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.

Acked-by: Alan Cox <alan@redhat.com>
