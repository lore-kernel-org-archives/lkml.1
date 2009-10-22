Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZJVW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZJVW40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZJVW4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:56:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbZJVW4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:56:23 -0400
Date: Thu, 22 Oct 2009 15:56:07 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: hv: Fix null pointer error after vmbus loading
Message-ID: <20091022225607.GB11244@suse.de>
References: <1FB5E1D5CA062146B38059374562DF72180B3E1E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72180B3E1E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 04:14:31PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Fix null pointer error after vmbus loading.

I'm not going to accept this patch, please see my previous email as to
why you should not be checking the name at all.

thanks,

greg k-h
