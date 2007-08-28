Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbXH1RPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbXH1RPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXH1RPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:15:43 -0400
Received: from fencepost.gnu.org ([140.186.70.10]:57516 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXH1RPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:15:42 -0400
Subject: Re: [PATCH] [360/2many] MAINTAINERS - ORINOCO DRIVER
From: Pavel Roskin <proski@gnu.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, hermes@gibson.dropbear.id.au,
       akpm@linux-foundation.org
In-Reply-To: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
References: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 13:15:22 -0400
Message-Id: <1188321322.2226.2.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 23:33 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 96aeb40..f374fa8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3463,6 +3463,7 @@ L:	orinoco-users@lists.sourceforge.net
>  L:	orinoco-devel@lists.sourceforge.net
>  W:	http://www.nongnu.org/orinoco/
>  S:	Maintained
> +F:	drivers/net/wireless/orinoco*

NAK.  Please also add airport*, spectrum* and hermes* in the same
directory.

Sorry for delay (due to vacation).

-- 
Regards,
Pavel Roskin

