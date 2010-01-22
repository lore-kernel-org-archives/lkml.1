Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412Ab0AVT7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0AVT7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277Ab0AVT7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:59:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:25160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab0AVT7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:59:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,326,1262592000"; 
   d="scan'208";a="589613388"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Greg KH <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>
Date: Fri, 22 Jan 2010 12:59:50 -0700
Subject: RE: Introduction to rar_register patch set of 5 patches
Thread-Topic: Introduction to rar_register patch set of 5 patches
Thread-Index: AcqbkYhIUuktxNPtRAGvXdDFa1140wAC56Pg
Message-ID: <8A0E4C92AE2D6D40AF99653191DA323160F7A280D1@rrsmsx501.amr.corp.intel.com>
References: <1264182811-28933-1-git-send-email-mark.a.allyn@intel.com>
 <20100122102308.bb17fd1a.rdunlap@xenotime.net>
 <20100122183322.GA9512@kroah.com>
In-Reply-To: <20100122183322.GA9512@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

Just to be clear; then only the overall description of RAR should be in the cover email?

Perhaps I over reacted to you earlier comment that each patch had too much, so I moved everything to the intro email. 

I will re-submit with the description of each patch in each patch, but I will still list the patches in the intro.

Mark

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Friday, January 22, 2010 10:33 AM
To: Randy Dunlap
Cc: Allyn, Mark A; linux-kernel@vger.kernel.org; alan@linux.intel.com; Johnson, Charles F
Subject: Re: Introduction to rar_register patch set of 5 patches

On Fri, Jan 22, 2010 at 10:23:08AM -0800, Randy Dunlap wrote:
> On Fri, 22 Jan 2010 09:53:30 -0800 Mark Allyn wrote:
> 
> > The following five patches are for the Restricted Access Region
> > Register (rar_register) driver.
> > 
> > This driver is for the Intel MID platform.
> 
> Hi Mark,
> 
> Please read and try to follow Documentation/SubmittingPatches.
> 
> E.g.:
> 
> "The canonical patch subject line is:
> 
>     Subject: [PATCH 001/123] subsystem: summary phrase"
> 
> so your patch 1 should be more like:
> 
> [PATCH 1/5] rar_register: rename rar_driver to rar_register
> 
> and then that one patch's description should be at the top of that
> email's body, not in the patch introduction/cover email.
> 
> As it stands, these 5 patch descriptions need to be moved
> to each patch's patch description...

I agree, I can not apply these as-is.

Mark, please redo the patches.

Hint, we do have tools that make this much easier, like quilt and git,
you might take the time to learn to use them so that future patch
submissions are not bungled as badly as these have been.

thanks,

greg k-h
