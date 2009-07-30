Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZG3P7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZG3P7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZG3P7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:59:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:33233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZG3P7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:59:41 -0400
Date: Thu, 30 Jul 2009 08:58:44 -0700
From: Greg KH <gregkh@suse.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Message-ID: <20090730155844.GB20557@suse.de>
References: <200907301737.23849.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907301737.23849.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 05:37:23PM +0200, Nicolas Palix wrote:
> 
> typedef SG_BUFFER_LIST is removed and its uses are replaced by the use of
> struct scatterlist.

Sweet!  thanks for doing this, very nice job, I'll go queue it up.

Hank, you are testing the linux-next tree to make sure we haven't broken
anything yet, right? :)

thanks,

greg k-h
