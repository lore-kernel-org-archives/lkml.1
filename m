Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbXHNQQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbXHNQQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 12:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXHNQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 12:15:45 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:37318 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbXHNQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 12:15:43 -0400
Date: Tue, 14 Aug 2007 09:15:40 -0700
From: Ron Mercer <ron.mercer@qlogic.com>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [396/2many] MAINTAINERS - QLOGIC QLAxxx NETWORK DRIVER
Message-ID: <20070814161540.GA4859@linux-7mw0.qlogic.org>
Mail-Followup-To: joe@perches.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <46bffb79.Z5A395zbCgcCCCAB%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffb79.Z5A395zbCgcCCCAB%joe@perches.com>
User-Agent: Mutt/1.5.9i
X-OriginalArrivalTime: 14 Aug 2007 16:14:39.0245 (UTC) FILETIME=[36FA63D0:01C7DE8E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:34:33PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1fa922a..6a99fe5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3790,6 +3790,8 @@ P:	Ron Mercer
>  M:	linux-driver@qlogic.com
>  L:	netdev@vger.kernel.org
>  S:	Supported
> +F:	Documentation/networking/LICENSE.qla3xxx
> +F:	drivers/net/qla3xxx.*
>  
>  QNX4 FILESYSTEM
>  P:	Anders Larsen

Acked-by: Ron Mercer <ron.mercer@qlogic.com>
