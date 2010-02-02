Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0BBNxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:53:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab0BBNxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:53:23 -0500
Date: Tue, 2 Feb 2010 14:53:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] tree-wide: trivial typo fixes: s/lenght/length/g
In-Reply-To: <1264751869-3997-1-git-send-email-daniel@caiaq.de>
Message-ID: <alpine.LNX.2.00.1002021453000.15395@pobox.suse.cz>
References: <1264751042-2657-1-git-send-email-daniel@caiaq.de> <1264751869-3997-1-git-send-email-daniel@caiaq.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Daniel Mack wrote:

> Some misspelled occurences of 'octet' and some comments were also fixed
> as I was on it.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Junio C Hamano <gitster@pobox.com>
> ---
> 
>  s/exceded/exceeded/ - Thanks to Joe.
> 
>  arch/arm/mach-at91/include/mach/at91_mci.h |    2 +-
>  arch/s390/crypto/sha_common.c              |    2 +-
>  drivers/crypto/hifn_795x.c                 |    2 +-
>  drivers/isdn/mISDN/l1oip_core.c            |    2 +-
>  drivers/net/ppp_generic.c                  |   15 +++++++--------
>  drivers/net/r6040.c                        |    2 +-
>  drivers/net/sb1000.c                       |    2 +-
>  drivers/net/stmmac/common.h                |    2 +-
>  drivers/net/stmmac/gmac.c                  |    4 ++--
>  drivers/net/stmmac/mac100.c                |    2 +-
>  drivers/net/stmmac/stmmac_ethtool.c        |    2 +-
>  drivers/net/wimax/i2400m/i2400m-usb.h      |    2 +-
>  drivers/net/wireless/p54/p54spi.c          |    2 +-
>  drivers/net/wireless/wl12xx/wl1251_cmd.c   |    2 +-
>  drivers/net/wireless/wl12xx/wl1251_rx.c    |    2 +-
>  drivers/net/wireless/wl12xx/wl1271_cmd.c   |    2 +-
>  drivers/usb/wusbcore/wusbhc.h              |    2 +-
>  drivers/uwb/uwbd.c                         |    2 +-
>  fs/cifs/asn1.c                             |    2 +-
>  fs/ext4/mballoc.c                          |    2 +-
>  fs/udf/inode.c                             |    2 +-
>  kernel/trace/trace.h                       |    2 +-
>  net/dccp/ackvec.h                          |    2 +-
>  net/ipv6/ip6_output.c                      |    2 +-
>  24 files changed, 31 insertions(+), 32 deletions(-)

Applied. thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
