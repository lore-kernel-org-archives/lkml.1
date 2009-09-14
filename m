Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZINO4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZINO4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZINO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:56:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:35420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbZINO42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:56:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="493262032"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 15:55:32 +0100
Subject: RE: [PATCH 19/29] ioat1: trim ioat_dma_desc_sw
Thread-Topic: [PATCH 19/29] ioat1: trim ioat_dma_desc_sw
Thread-Index: AcotB+cNVk5nVEy0TKeM+FYItKV3fwIQ1boQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548181@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023206.32667.35974.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023206.32667.35974.stgit@dwillia2-linux.ch.intel.com>
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
> Save 4 bytes per software descriptor by transmitting tx_cnt in an unused
> portion of the hardware descriptor.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>