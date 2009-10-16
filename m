Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbZJPN0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbZJPN0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbZJPN0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:26:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:37180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759545AbZJPN0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:26:02 -0400
Date: Fri, 16 Oct 2009 15:25:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] trivial: fix typo s/assocate/associate/ in comment
In-Reply-To: <1255637738-6069-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0910161525190.8582@wotan.suse.de>
References: <1255637738-6069-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
> index b14ba07..b73e7d3 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -192,7 +192,7 @@ struct ath5k_softc {
>  	struct ath5k_txq	*cabq;		/* content after beacon */
>  
>  	int 			power_level;	/* Requested tx power in dbm */
> -	bool			assoc;		/* assocate state */
> +	bool			assoc;		/* associate state */
>  	bool			enable_beacon;	/* true if beacons are on */
>  };

Merged together with patches 2-8 from your series and applied to trivial
queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
