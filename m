Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZHLGvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZHLGvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZHLGvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:51:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:62323 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZHLGvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,365,1246863600"; 
   d="scan'208";a="174870193"
Date: Wed, 12 Aug 2009 14:51:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation/vm/.gitignore: Add page-types
Message-ID: <20090812065107.GA16363@localhost>
References: <20090808173900.GA21009@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808173900.GA21009@feather>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh,

Good catch, thanks.

btw, maybe we can move page-types into the newly created tools/ dir?

Thanks,
Fengguang

On Sun, Aug 09, 2009 at 01:39:00AM +0800, Josh Triplett wrote:
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  Documentation/vm/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
> index 33e8a02..09b164a 100644
> --- a/Documentation/vm/.gitignore
> +++ b/Documentation/vm/.gitignore
> @@ -1 +1,2 @@
> +page-types
>  slabinfo
> -- 
> 1.5.6.5
