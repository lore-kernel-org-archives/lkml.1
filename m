Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbXIISiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbXIISiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXIISiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:38:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49092 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbXIISiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:38:07 -0400
Date: Sun, 9 Sep 2007 20:39:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] powerpc: proper defconfig for crosscompiles
Message-ID: <20070909183929.GA20443@uranus.ravnborg.org>
References: <20070909182117.GJ3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909182117.GJ3563@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 08:21:17PM +0200, Adrian Bunk wrote:
> The trick for finding the right defconfig is neat, but you forgot to 
> provide an i686_defconfig.  ;-)
> 
> More seriously, cross compiling the defconfig is often useful, e.g. for 
> testing the compilation of patches that touch multiple architectures, 
> and this patch therefore chooses g5_defconfig if $(CROSS_COMPILE) is 
> non-empty.

Thanks - much appreciated.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
