Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbZINPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbZINPB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbZINPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:01:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:14457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbZINPBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="187386210"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 16:01:26 +0100
Subject: RE: [PATCH 26/29] ioat: implement a private tx_list
Thread-Topic: [PATCH 26/29] ioat: implement a private tx_list
Thread-Index: AcotB/wqYP9gKeZJS1OKvgrYpNlLzwIRDV1Q
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548197@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023242.32667.27473.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023242.32667.27473.stgit@dwillia2-linux.ch.intel.com>
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
> Drop ioatdma's use of tx_list from struct dma_async_tx_descriptor in
> preparation for removal of this field.
> 
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>