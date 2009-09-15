Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZIOQGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZIOQGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZIOQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:06:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:40340 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZIOQGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,391,1249282800"; 
   d="scan'208";a="448702363"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:06:02 +0100
Subject: RE: [PATCH 03/18] dmaengine: cleanup unused transaction types
Thread-Topic: [PATCH 03/18] dmaengine: cleanup unused transaction types
Thread-Index: AcotKzVgnYCX7o53Sj6+L5T+LMySmQI8yWRw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548788@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064450.7141.51497.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064450.7141.51497.stgit@dwillia2-linux.ch.intel.com>
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
> No drivers currently implement these operation types, so they can be
> deleted.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
