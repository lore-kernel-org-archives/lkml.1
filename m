Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbXC3U43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbXC3U43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXC3U43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:56:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXC3U42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:56:28 -0400
Message-ID: <460D796F.2020309@redhat.com>
Date: Fri, 30 Mar 2007 16:56:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Mitch A wrote:
> 
> If Eric is seeing bug reports related to "no vector for IRQ" in the
> wild, then I have to change my stance and agree that this should be
> pushed to -stable.  Every one of those messages indicates that we
> hit the race condition.
> 

Your previous patch is in a Fedora test kernel. Hopefully I will
have some feedback soon.

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=225399
