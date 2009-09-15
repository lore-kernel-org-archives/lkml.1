Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZIOQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZIOQJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZIOQJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:09:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:25840 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbZIOQJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:09:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727157446"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:08:08 +0100
Subject: RE: [PATCH 08/18] ioat: add 'ioat' sysfs attributes
Thread-Topic: [PATCH 08/18] ioat: add 'ioat' sysfs attributes
Thread-Index: AcotK0R3Hb58CN5TROODNeGQ6jBiZAI82ghQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548794@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064515.7141.3535.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064515.7141.3535.stgit@dwillia2-linux.ch.intel.com>
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
> Export driver attributes for diagnostic purposes:
> 'ring_size': total number of descriptors available to the engine
> 'ring_active': number of descriptors in-flight
> 'capabilities': supported operation types for this channel
> 'version': Intel(R) QuickData specfication revision
> 
> This also allows some chattiness to be removed from the driver startup
> as this information is now available via sysfs.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>