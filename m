Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXFNVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXFNVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXFNVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:40:12 -0400
Received: from sd291.sivit.org ([194.146.225.122]:3610 "EHLO sd291.sivit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXFNVkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:40:10 -0400
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 17:40:10 EDT
Date: Thu, 14 Jun 2007 23:09:03 +0200
From: Stelian Pop <stelian@popies.net>
To: vignesh babu <vignesh.babu@wipro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Subject: Re: [PATCH]is_power_of_2-kernel/kfifo.c
Message-ID: <20070614210903.GA18833@sd291.sivit.org>
Reply-To: Stelian Pop <stelian@popies.net>
Mail-Followup-To: Stelian Pop <stelian@popies.net>,
	vignesh babu <vignesh.babu@wipro.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Kernel Janitors List <kernel-janitors@lists.osdl.org>
References: <1181817306.2474.22.camel@merlin.linuxcoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181817306.2474.22.camel@merlin.linuxcoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 04:05:06PM +0530, vignesh babu wrote:
> 
> 
> Replacing (n & (n-1)) in the context of power of 2 checks
> with is_power_of_2
> 
> Signed-off-by: vignesh babu <vignesh.babu@wipro.com>

Signed-off-by: Stelian Pop <stelian@popies.net>

Thanks,

Stelian.
-- 
Stelian Pop <stelian@popies.net>    
