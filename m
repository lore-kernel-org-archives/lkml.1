Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbZG3QXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbZG3QXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZG3QXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:23:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:34204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZG3QXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:23:46 -0400
Date: Thu, 30 Jul 2009 09:20:01 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Nicolas Palix <npalix@diku.dk>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Message-ID: <20090730162001.GA32165@suse.de>
References: <200907301737.23849.npalix@diku.dk>
 <20090730155844.GB20557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56209A92425@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56209A92425@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 04:14:57PM +0000, Hank Janssen wrote:
> 
> 
> So far so good it seems, I have been doing some of the integration
> tests and all seems well.

great, thanks for letting us know.

greg k-h
