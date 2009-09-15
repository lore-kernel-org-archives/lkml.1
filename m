Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZIOQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZIOQLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZIOQLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:11:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:53649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZIOQLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:11:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="493669470"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "Picard, Tom S" <tom.s.picard@intel.com>
Date: Tue, 15 Sep 2009 17:10:32 +0100
Subject: RE: [PATCH 15/18] ioat3: ioat3.2 pci ids for Jasper Forest
Thread-Topic: [PATCH 15/18] ioat3: ioat3.2 pci ids for Jasper Forest
Thread-Index: AcotK1joT1cvOQicR2iifQb8YUQZjAI8605w
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554879C@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
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
> From: Tom Picard <tom.s.picard@intel.com>
> 
> Jasper Forest introduces raid offload support via ioat3.2 support.  When
> raid offload is enabled two (out of 8 channels) will report raid5/raid6
> offload capabilities.  The remaining channels will only report ioat3.0
> capabilities (memcpy).
> 
> Signed-off-by: Tom Picard <tom.s.picard@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>