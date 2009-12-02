Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZLBNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZLBNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZLBNI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:08:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59629 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZLBNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:08:28 -0500
Date: Wed, 2 Dec 2009 14:08:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/24] page-types: add standard GPL license head
Message-ID: <20091202130834.GC18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043043.715851393@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043043.715851393@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:12:32AM +0800, Wu Fengguang wrote:

> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/vm/page-types.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> --- linux-mm.orig/Documentation/vm/page-types.c	2009-11-07 19:28:51.000000000 +0800
> +++ linux-mm/Documentation/vm/page-types.c	2009-11-08 22:04:04.000000000 +0800
> @@ -1,11 +1,22 @@
>  /*
>   * page-types: Tool for querying page flags
>   *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; version 2.

I guess it's not fully hwpoison department, but I'll just include it
because it's so simple.
-Andi
