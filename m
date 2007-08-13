Return-Path: <linux-kernel-owner+w=401wt.eu-S973032AbXHMQKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973032AbXHMQKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947502AbXHMOuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:50:20 -0400
Received: from ns1.coraid.com ([65.14.39.133]:24546 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S945262AbXHMOuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:50:15 -0400
Date: Mon, 13 Aug 2007 10:50:39 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [73/2many] MAINTAINERS - ATA OVER ETHERNET DRIVER
Message-ID: <20070813145039.GD6658@coraid.com>
References: <46bff8ed.gfAxHwWrSc/PwGwN%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bff8ed.gfAxHwWrSc/PwGwN%joe@perches.com>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:23:41PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a165698..b8bb108 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -740,6 +740,8 @@ P:	Ed L. Cashin
>  M:	ecashin@coraid.com
>  W:	http://www.coraid.com/support/linux
>  S:	Supported
> +F:	Documentation/aoe/
> +F:	drivers/block/aoe/
>  
>  ATL1 ETHERNET DRIVER
>  P:	Jay Cliburn

That looks fine to me.

-- 
  Ed L Cashin <ecashin@coraid.com>
