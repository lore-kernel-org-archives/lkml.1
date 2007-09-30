Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXI3UfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXI3UfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXI3UfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:35:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42405 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXI3UfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:35:08 -0400
Date: Sun, 30 Sep 2007 22:35:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       vojtech@suse.cz
Subject: Re: [PATCH] Documentation/x86_64/00-INDEX
Message-ID: <20070930203503.GA9748@one.firstfloor.org>
References: <200709281944.02953.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709281944.02953.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 07:44:02PM -0500, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Add Documentation/x86_64/00-INDEX

What's the point of this file?

>  x86_64/00-INDEX |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> +++ Documentation/x86_64/00-INDEX	2007-09-28 19:40:56.000000000 -0500
> @@ -0,0 +1,14 @@
> +00-INDEX
> +	- This file
> +boot-options.txt
> +	- AMD64-specific boot options.

The architecture is not called AMD64 under Linux.

> +mm.txt
> +	- Memory layout of x86-64 (4 level page tables, 46 bits physical).

I don't think such details as the 46 bit number should be in an index file.

-Andi
