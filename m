Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZFWRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZFWRbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZFWRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:30:43 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:1295 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZFWRal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:30:41 -0400
X-IronPort-AV: E=Sophos;i="4.42,276,1243814400"; 
   d="scan'208";a="179554962"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       raisch@de.ibm.com, ewg@lists.openfabrics.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Subject: Re: [ewg] Re: [PATCH 2.6.31 try 2] ehca: Tolerate dynamic memory operations and huge pages
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
	<20090616091021.2acf7302@BL3D1974.boeblingen.de.ibm.com>
	<adabpofr0h2.fsf@cisco.com>
	<20090623101123.72690731@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 23 Jun 2009 10:30:43 -0700
In-Reply-To: <20090623101123.72690731@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Tue, 23 Jun 2009 10:11:23 +0200")
Message-ID: <adaljniq2m4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2009 17:30:43.0779 (UTC) FILETIME=[56234130:01C9F428]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied...
