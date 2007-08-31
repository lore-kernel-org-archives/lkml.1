Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXHaVni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXHaVni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXHaVnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:43:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:41690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXHaVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:43:23 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
Date: Fri, 31 Aug 2007 17:41:22 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Tony Luck <tony.luck@intel.com>, John Stultz <johnstul@us.ibm.com>,
       Paolo Ornati <ornati@fastwebnet.it>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Stephen Ziemba <sziemba@ecn.purdue.edu>
References: <46D59081.2040605@googlemail.com>
In-Reply-To: <46D59081.2040605@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311741.22863.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 11:28, Michal Piotrowski wrote:

> ACPI
> 
> Subject         : the fan doesn't work any more
> References      : http://lkml.org/lkml/2007/8/28/359
> Last known good : ?
> Submitter       : Daniel Ritz <daniel.ritz-ml@swissonline.ch>
> Caused-By       : Alexey Starikovskiy <astarikovskiy@suse.de>
>                   commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch           : http://lkml.org/lkml/2007/8/29/15
> Status          : patch was suggested

I believe that this is gone as of 2.6.23-rc4-git3

http://bugzilla.kernel.org/show_bug.cgi?id=8958

thanks,
-Len
