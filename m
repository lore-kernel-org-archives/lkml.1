Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0BLAMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:12:07 -0500
Received: from ozlabs.org ([203.10.76.45]:51583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509Ab0BLAMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:12:03 -0500
Date: Fri, 12 Feb 2010 11:11:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Greg KH <gregkh@suse.de>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Message-ID: <20100212001159.GC13769@brick.ozlabs.ibm.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213816.GB29557@suse.de>
 <20100211232056.GA13769@brick.ozlabs.ibm.com>
 <20100211233234.GA10315@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56212E8847D@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E8847D@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 11:46:48PM +0000, Hank Janssen wrote:
> >> On a side note, when this becomes mainstream, could you give it a more
> >> descriptive name than just "hv"?  "Hv" already means at least two
> >> possible things to me -- "hypervisor" or "high volume" -- neither of
> >> which appear to be what this code is about.
> >
> >"hyperv" should be sufficient, right?
> >
> >thanks,
> >
> >greg k-h
> 
> I was thinking of using that, but would that confuse it with hypervisor
> which is more of a general term?  If the consensus is that it would not than
> I am in favor of changing it to hyperv.
> 
> ms_hyperv would make it to long?

I don't believe "hyperv" is a generally-used abbreviation of
"hypervisor".  You could do "ms_hyperv" if you like, but I wouldn't
regard the "ms_" prefix as essential.

Paul.
