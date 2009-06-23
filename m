Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZFWFT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZFWFT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZFWFTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:19:20 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:58692 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZFWFTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:19:19 -0400
X-IronPort-AV: E=Sophos;i="4.42,273,1243814400"; 
   d="scan'208";a="179305183"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       raisch@de.ibm.com, ewg@lists.openfabrics.org,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [ewg] Re: [PATCH 2.6.31 try 2] ehca: Tolerate dynamic memory operations and huge pages
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
	<20090616091021.2acf7302@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 22 Jun 2009 22:19:21 -0700
In-Reply-To: <20090616091021.2acf7302@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Tue, 16 Jun 2009 09:10:21 +0200")
Message-ID: <adabpofr0h2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2009 05:19:21.0828 (UTC) FILETIME=[2A74EA40:01C9F3C2]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.

 > -#define HCAD_VERSION "0026"
 > +#define HCAD_VERSION "0027"

the driver version was already 0027 (since bde2cfaf), so I dropped this chunk.
