Return-Path: <linux-kernel-owner+w=401wt.eu-S1031280AbXHMNY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280AbXHMNY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971735AbXHMJT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:19:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:14600 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970414AbXHMJT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:19:56 -0400
Message-ID: <5640c7e00708130219i463817bbu2b4c3e299b778cf4@mail.gmail.com>
Date: Mon, 13 Aug 2007 21:19:54 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [148/2many] MAINTAINERS - DCCP PROTOCOL
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dccp@vger.kernel.org, akpm@linux-foundation.org,
       acme@ghostprotocols.net
In-Reply-To: <46bff97c.9avHEM3TinhF1DrA%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff97c.9avHEM3TinhF1DrA%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f54480..c786066 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1434,6 +1434,8 @@ M:        acme@ghostprotocols.net
>  L:     dccp@vger.kernel.org
>  W:     http://linux-net.osdl.org/index.php/DCCP
>  S:     Maintained
> +F:     include/linux/dccp.h
> +F:     net/dccp/
>
Provided this patch series goes in then we need to add this in as well
as part of DCCP subsystem:
F:  include/linux/tfrc.h

Once this is done, and series goes in then:
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
-- 
Web1: http://wand.net.nz/~iam4/
Web2: http://www.jandi.co.nz
Blog: http://iansblog.jandi.co.nz
