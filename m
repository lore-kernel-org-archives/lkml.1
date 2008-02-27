Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYB0Vky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYB0Vky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYB0Vkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:40:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:40247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879AbYB0Vkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:40:41 -0500
Date: Wed, 27 Feb 2008 22:40:40 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/char/rtc.c: make 2 functions static
Message-ID: <20080227214038.GA31795@suse.de>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org
References: <20080227212009.GF29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227212009.GF29269@cs181133002.pp.htv.fi>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk <bunk@kernel.org> [2008-02-27 22:20]:
> The following functions can now become static:
> - rtc_interrupt()
> - rtc_get_rtc_time()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Of course:

Acked-by: Bernhard Walle <bwalle@suse.de>

But I'm not the maintainer of RTC ...

