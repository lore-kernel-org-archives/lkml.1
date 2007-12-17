Return-Path: <linux-kernel-owner+w=401wt.eu-S937130AbXLQUMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937130AbXLQUMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbXLQTtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:49:53 -0500
Received: from mailhub.hp.com ([192.151.27.10]:45629 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935069AbXLQTtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:49:52 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] net/netlabel/: Spelling fixes
Date: Mon, 17 Dec 2007 14:49:23 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org
References: <1197920439-5455-29-git-send-email-joe@perches.com>
In-Reply-To: <1197920439-5455-29-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171449.24007.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 December 2007 2:40:35 pm Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks Joe.

Acked-by: Paul Moore <paul.moore@hp.com>

> ---
>  net/netlabel/netlabel_mgmt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index 5648337..9c41464 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -71,7 +71,7 @@ static const struct nla_policy
> netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = { };
>
>  /*
> - * NetLabel Misc Managment Functions
> + * NetLabel Misc Management Functions
>   */
>
>  /**



-- 
paul moore
linux security @ hp
