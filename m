Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZL1QJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZL1QJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 11:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZL1QJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 11:09:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:44516 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZL1QJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 11:09:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,459,1257148800"; 
   d="scan'208";a="526759011"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Dec 2009 16:09:11 +0000
Subject: RE: [PATCH 2/3] async_tx: expand async raid6 test to cover ioatdma
 corner	case
Thread-Topic: [PATCH 2/3] async_tx: expand async raid6 test to cover ioatdma
 corner	case
Thread-Index: AcqDZqz/LuHkiPD9S4+8OscwC5/7GQEcV5gA
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710BB@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
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
> Add explicit 11 and 12 disks cases to exercise the 0 < src_cnt % 8 < 3
> corner case in the ioatdma driver.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
