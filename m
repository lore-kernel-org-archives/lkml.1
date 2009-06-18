Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZFRPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZFRPin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFRPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:38:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1347 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFRPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:38:32 -0400
Subject: Re: [PATCH 2/2] MAINTAINERS: fix address of IEEE 802.15.4 git tree
From: Joe Perches <joe@perches.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, slapin@ossfans.org
In-Reply-To: <1245334607-16046-3-git-send-email-dbaryshkov@gmail.com>
References: <1245334607-16046-1-git-send-email-dbaryshkov@gmail.com>
	 <1245334607-16046-2-git-send-email-dbaryshkov@gmail.com>
	 <1245334607-16046-3-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 08:38:30 -0700
Message-Id: <1245339510.29927.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 18:16 +0400, Dmitry Eremin-Solenikov wrote:
> IEEE 802.15.4 git tree was moved from my private area to shared one.
> Fix address accordingly.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61c190a..e1cfb12 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2826,7 +2826,7 @@ P:	Sergey Lapin
>  M:	slapin@ossfans.org
>  L:	linux-zigbee-devel@lists.sourceforge.net
>  W:	http://apps.sourceforge.net/trac/linux-zigbee
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
>  S:	Maintained
>  F:	net/ieee802154/
>  F:	drivers/ieee801254/

Can you fix the pattern typo too please

-F:	drivers/ieee801254
+F:	drivers/ieee802154

