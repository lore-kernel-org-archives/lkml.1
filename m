Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZIOQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZIOQGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZIOQGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:06:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:18994 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZIOQGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,391,1249282800"; 
   d="scan'208";a="448702477"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:06:23 +0100
Subject: RE: [PATCH 04/18] dmaengine, async_tx: support alignment checks
Thread-Topic: [PATCH 04/18] dmaengine, async_tx: support alignment checks
Thread-Index: AcotKze5VnvaPJ0+SFOA/WEz0jz4eAI8zdTQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554878A@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064455.7141.41620.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064455.7141.41620.stgit@dwillia2-linux.ch.intel.com>
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
> Some engines have transfer size and address alignment restrictions.  Add
> a per-operation alignment property to struct dma_device that the async
> routines and dmatest can use to check alignment capabilities.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>