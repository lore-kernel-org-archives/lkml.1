Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXC2WGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXC2WGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXC2WGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:06:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:9538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422646AbXC2WGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,348,1170662400"; 
   d="scan'208"; a="218843393:sNHT22169216076"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
Date: Thu, 29 Mar 2007 15:05:56 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EFCDB2B@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <460BF68E.9030806@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
Thread-Index: AcdyJ1tRP7BrERnSQaqXja5jTgkqFwAJn+nw
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Cc: <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <ebiederm@xmission.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 29 Mar 2007 22:05:57.0334 (UTC) FILETIME=[6D7E0760:01C7724E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>Are you going to post one for 2.6.20 as well? Some people might be
>interested...

The first time I posted this patch, Greg KH indicated that he thought
it was too intrusive to add to -stable, especially considering that
our MSI-X capable hardware isn't in the field yet.

So the answer to your question is, "probably not".
-Mitch
