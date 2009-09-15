Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZIOQLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZIOQLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZIOQLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:11:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:35942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbZIOQL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:11:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727158214"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       Roland Dreier <rolandd@cisco.com>
Date: Tue, 15 Sep 2009 17:11:01 +0100
Subject: RE: [PATCH 17/18] Add MODULE_DEVICE_TABLE() so ioatdma module is
	autoloaded
Thread-Topic: [PATCH 17/18] Add MODULE_DEVICE_TABLE() so ioatdma module is
	autoloaded
Thread-Index: AcotK17g1aOvfVGBQEKylnmzW/b8PgI87hPg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554879E@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064601.7141.18599.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064601.7141.18599.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> From: Roland Dreier <rdreier@cisco.com>
> 
> The ioatdma module is missing aliases for the PCI devices it supports,
> so it is not autoloaded on boot.  Add a MODULE_DEVICE_TABLE() to get
> these aliases.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>