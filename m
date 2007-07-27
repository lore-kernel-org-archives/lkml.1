Return-Path: <linux-kernel-owner+w=401wt.eu-S938536AbXG0X53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938536AbXG0X53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938044AbXG0X5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:57:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:53787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765640AbXG0X5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:57:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,192,1183359600"; 
   d="scan'208";a="273700336"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [1/2] 2.6.23-rc1: known regressions with patches v2
Date: Fri, 27 Jul 2007 16:57:18 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0209BC14@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46AA5B44.2030909@googlemail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [1/2] 2.6.23-rc1: known regressions with patches v2
Thread-Index: AcfQkJJSthQHdvJCSh6UJwv1Bldq9gAGNASA
From: "Luck, Tony" <tony.luck@intel.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Kay Sievers" <kay.sievers@gmail.com>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Vitaly Bordug" <vitb@kernel.crashing.org>,
       <linux-fsdevel@vger.kernel.org>, "Doug Chapman" <doug.chapman@hp.com>,
       "Vasily Tarasov" <vtaras@openvz.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>
X-OriginalArrivalTime: 27 Jul 2007 23:57:18.0998 (UTC) FILETIME=[DDA50B60:01C7D0A9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject         : ia64 build failure from recent diskquota patch
> References      : http://lkml.org/lkml/2007/7/18/407
> Last known good : ?
> Submitter       : Doug Chapman <doug.chapman@hp.com>
> Caused-By       : Vasily Tarasov <vtaras@openvz.org>
>                   commit b716395e2b8e450e294537de0c91476ded2f0395
> Handled-By      : Luck, Tony <tony.luck@intel.com>
> Patch1          : http://lkml.org/lkml/2007/7/20/255
> Patch2          : http://lkml.org/lkml/2007/7/20/272
> Status          : patch available

Just sent the "please pull" message to Linus.  The fix should show up in
his tree soon as commit 7a6c813594c9eb25a9afbcbd30c9865e38ee6f39

-Tony
