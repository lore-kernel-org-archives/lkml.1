Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYGATNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYGATNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYGATNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:13:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:33292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbYGATNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,732,1204531200"; 
   d="scan'208";a="583993504"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel DG965WH / Case 745-44-22 (slow bios/upgrade) [UPDATE] / Intel, status of HECI support patch for the kernel?
Date: Tue, 1 Jul 2008 12:13:03 -0700
User-Agent: KMail/1.9.9
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "Nashif, Anas" <anas.nashif@intel.com>
References: <alpine.DEB.1.10.0806300958070.13171@p34.internal.lan> <200807011158.46258.jesse.barnes@intel.com> <alpine.DEB.1.10.0807011506450.18141@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0807011506450.18141@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011213.03405.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2008 12:08 pm Justin Piszcz wrote:
> >> All issues are now resolved (regarding the slow speed/memory/etc)..
> >
> > Hopefully there's a more recent BIOS available that doesn't need to trim
> > the memory for you?
>
> Erm, that is what I am trying to get across, version 1738 of the BIOS has
> successfully solved the memory mapping/non-cachable memory issue.

Oh, great.  Good to hear we actually fix those bugs! :)

Thanks,
Jesse
