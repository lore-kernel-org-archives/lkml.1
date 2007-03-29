Return-Path: <linux-kernel-owner+w=401wt.eu-S1422672AbXC2WOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672AbXC2WOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422682AbXC2WOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:14:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422672AbXC2WOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:14:46 -0400
Message-ID: <460C3A3C.3070904@redhat.com>
Date: Thu, 29 Mar 2007 18:14:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
References: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB2B@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB2B@fmsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Mitch A wrote:
> Chuck Ebbert wrote:
>> Are you going to post one for 2.6.20 as well? Some people might be
>> interested...
> 
> The first time I posted this patch, Greg KH indicated that he thought
> it was too intrusive to add to -stable, especially considering that
> our MSI-X capable hardware isn't in the field yet.
> 
> So the answer to your question is, "probably not".

So it's not useful in 2.6.20 for anything that's available today, from
any vendor? We can put it in Fedora if you think it is.

