Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZHRR7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZHRR7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZHRR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:59:13 -0400
Received: from kroah.org ([198.145.64.141]:33788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZHRR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:59:12 -0400
Date: Tue, 18 Aug 2009 10:35:17 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: sep: fix warnings
Message-ID: <20090818173517.GE6123@kroah.com>
References: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
 <1250588932-7595-2-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250588932-7595-2-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:48:52PM +0400, Alexander Beregalov wrote:
> Fix this warnings
> drivers/staging/sep/sep_driver.c:290: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
> drivers/staging/sep/sep_driver.c:382: warning: unused variable 'sep'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

This doesn't apply due to all of the patches from Alan that went into
linux-next yeserday for this driver.  Care to respin this tomorrow if
it's still an issue?

thanks,

greg k-h
