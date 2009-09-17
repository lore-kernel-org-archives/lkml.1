Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZIQQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZIQQlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZIQQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:41:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:63779 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbZIQQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,404,1249282800"; 
   d="scan'208";a="494430304"
Date: Thu, 17 Sep 2009 09:41:46 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI/VGA: fix header commentary
Message-ID: <20090917094146.736d98e0@jbarnes-g45>
In-Reply-To: <1252767751-27914-1-git-send-email-tiago.vignatti@nokia.com>
References: <20090817103733.6b525fb4@jbarnes-g45>
	<1252767751-27914-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009 18:02:31 +0300
Tiago Vignatti <tiago.vignatti@nokia.com> wrote:

> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> ---
> 
> Amend this somewhere, Jesse. Thanks.
> 
> 
>  include/linux/vgaarb.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> index e81c64a..290409c 100644
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -1,5 +1,5 @@
>  /*
> - * vgaarb.c
> + * vgaarb.h
>   *
>   * (C) Copyright 2005 Benjamin Herrenschmidt
> <benh@kernel.crashing.org>
>   * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>

I removed the referenced to the filename altogether and replaced it
with a short comment.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
