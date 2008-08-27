Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYH0KsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYH0KsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYH0KsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:48:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:55884 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753799AbYH0KsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:48:11 -0400
Date: Wed, 27 Aug 2008 12:48:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alex Chiang <achiang@hp.com>
cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix grammo in HID_COMPAT Kconfig help text
In-Reply-To: <20080827013136.GA21966@ldl.fc.hp.com>
Message-ID: <alpine.LNX.1.10.0808271247580.3260@jikos.suse.cz>
References: <20080827013136.GA21966@ldl.fc.hp.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Alex Chiang wrote:

> The Kconfig option for HID_COMPAT should read "lose", not "loose".
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 4319af3..46337a2 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -78,7 +78,7 @@ config HID_COMPAT
>  	support of module loading through aliases and also old
>  	module-init-tools which can't handle hid bus, choose Y here. Otherwise
>  	say N. If you say N and your userspace is old enough, the only
> -	functionality you loose is modules autoloading.
> +	functionality you lose is modules autoloading.
>  
>  	If unsure, say Y.

Applied on top of hidbus patches, thanks Alex.

-- 
Jiri Kosina
SUSE Labs
