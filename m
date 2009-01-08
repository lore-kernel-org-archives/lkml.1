Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbZAHSRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbZAHSRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZAHSR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:17:26 -0500
Received: from mga10.intel.com ([192.55.52.92]:50520 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761523AbZAHSRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:17:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,235,1231142400"; 
   d="scan'208";a="655616814"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] wimax: fix compile bug
Date: Thu, 8 Jan 2009 10:11:56 -0800
User-Agent: KMail/1.9.9
Cc: gregkh@suse.de, heiko.carstens@de.ibm.com, torvalds@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
References: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com> <20090108165254.GA13737@suse.de> <20090108.085806.43922610.davem@davemloft.net>
In-Reply-To: <20090108.085806.43922610.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081011.57294.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Thu, 8 Jan 2009 08:52:54 -0800
>
> > On Thu, Jan 08, 2009 at 05:12:22PM +0100, Heiko Carstens wrote:
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > >
> > > wimax should depend on INPUT:
> >
> > <snip>
> >
> > Inaky just sent a series of 3 patches to the netdev mailing list fixing
> > this up in a much better way.
>
> Yep, I'll be integrating his patches during the course of
> today.

Thanks David

Please be sure to integrate v3 of the patchset
(http://lkml.org/lkml/2009/1/7/397), shows as the 1/4 series
in patchwork.ozlabs.org.

-- 
Inaky
