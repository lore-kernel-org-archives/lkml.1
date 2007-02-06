Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXBFW2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXBFW2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXBFW2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:28:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51959 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030190AbXBFW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:28:24 -0500
Date: Tue, 6 Feb 2007 22:38:18 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, adaplas@pol.net,
       linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [2.6 patch] remove the broken FB_S3TRIO driver
Message-ID: <20070206223818.3e5d1059@localhost.localdomain>
In-Reply-To: <20070206220953.GE27397@stusta.de>
References: <20070206220953.GE27397@stusta.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 23:09:53 +0100
Adrian Bunk <bunk@stusta.de> wrote:

> The FB_S3TRIO driver:
> - has been marked as BROKEN for more than two years and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Alan Cox <alan@redhat.com>
