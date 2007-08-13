Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXHMWhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXHMWhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXHMWgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:36:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3809 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764116AbXHMWgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:36:44 -0400
Subject: Re: [PATCH] [392/2many] MAINTAINERS - PS3 PLATFORM SUPPORT
From: Joe Perches <joe@perches.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       akpm@linux-foundation.org
In-Reply-To: <46C0DA2B.6080407@am.sony.com>
References: <46bffb71.JWcVvIR5pg3biTEh%joe@perches.com>
	 <46C0DA2B.6080407@am.sony.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 15:36:27 -0700
Message-Id: <1187044587.10249.333.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 15:24 -0700, Geoff Levand wrote:
> +F:	include/asm-powerpc/lv1call.h

Added to my tree.

PS3 PLATFORM SUPPORT
P:	Geoff Levand
M:	geoffrey.levand@am.sony.com
L:	linuxppc-dev@ozlabs.org
L:	cbe-oss-dev@ozlabs.org
S:	Supported
F:	arch/powerpc/boot/ps3*
F:	arch/powerpc/platforms/ps3/
F:	drivers/*/ps3*
F:	drivers/ps3/
F:	drivers/usb/host/*ps3.c
F:	include/asm-powerpc/ps3*
F:	include/asm-powerpc/lv1call.h


