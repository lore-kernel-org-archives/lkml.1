Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0BWITm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:19:42 -0500
Received: from mga10.intel.com ([192.55.52.92]:10282 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124Ab0BWITl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:19:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,525,1262592000"; 
   d="scan'208";a="543059184"
Date: Tue, 23 Feb 2010 09:20:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mike Rapoport <mike@compulab.co.il>, LKML <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH v3 2/3] i2c: convert i2c-isch to platform_device
Message-ID: <20100223082054.GA3550@sortiz.org>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DBB2.7020601@compulab.co.il>
 <4B7C0E5D.3070909@compulab.co.il>
 <4B812B42.2090405@compulab.co.il>
 <4B837D0C.3000708@compulab.co.il>
 <20100223091221.086ff17b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223091221.086ff17b@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, Feb 23, 2010 at 09:12:21AM +0100, Jean Delvare wrote:
> Hi Mike,
> 
> On Tue, 23 Feb 2010 09:00:28 +0200, Mike Rapoport wrote:
> > Hi Jean,
> > 
> > Denis Turischev wrote:
> > > v2: there is no acpi_check_region, it will be implemented in mfd-core
> > > v3: patch refreshed against the latest Linus tree
> > > 
> > > Signed-off-by: Denis Turischev <denis@compulab.co.il>
> > 
> > Any chance this can go to 2.6.34?
> 
> I can add my
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> but the patch itself would rather go through Samuel's mfd tree. The
> different patches depend on each other so pushing them through
> different trees would cause trouble.
Exactly. I asked Denis to rebase them against Linus' latest because I was
planning to merge them through my tree.
I'll take patches 2 and 3 from this patchset.

Cheers,
Samuel.


> -- 
> Jean Delvare

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
