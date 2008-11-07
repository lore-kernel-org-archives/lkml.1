Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYKGCHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYKGCHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYKGCHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:07:21 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:38077 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGCHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:07:20 -0500
Date: Thu, 06 Nov 2008 21:07:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] PNP: add Bjorn Helgaas as PNP co-maintainer
In-reply-to: <20080801160047.28518.51260.stgit@tigger.helgaas>
X-X-Sender: lenb@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Rene Herman <rene.herman@keyaccess.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811062106270.3106@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080801160047.28518.51260.stgit@tigger.helgaas>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

sorry, i guess this one fell between the cracks in the andi->lenb handoff.

thanks,
-Len

On Fri, 1 Aug 2008, Bjorn Helgaas wrote:

> 
> Update Adam's email address and add myself as PNP co-maintainer.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 
>  MAINTAINERS |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index deedc0d..3ae0e33 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3314,7 +3314,9 @@ S:	Maintained
>  
>  PNP SUPPORT
>  P:	Adam Belay
> -M:	ambx1@neo.rr.com
> +M:	abelay@mit.edu
> +P:	Bjorn Helgaas
> +M:	bjorn.helgaas@hp.com
>  S:	Maintained
>  
>  PNXxxxx I2C DRIVER
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
