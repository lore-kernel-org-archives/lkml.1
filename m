Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZIOQLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZIOQLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZIOQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:10:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:22565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbZIOQKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727158026"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:09:31 +0100
Subject: RE: [PATCH 12/18] ioat3: pq support
Thread-Topic: [PATCH 12/18] ioat3: pq support
Thread-Index: AcotK1HbJEKdk73IRi2a6WCVyXm2kQI842Bw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548798@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064536.7141.4263.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064536.7141.4263.stgit@dwillia2-linux.ch.intel.com>
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
> ioat3.2 adds support for raid6 syndrome generation (xor sum of galois
> field multiplication products) using up to 8 sources.  It can also
> perform an pq-zero-sum operation to validate whether the syndrome for a
> given set of sources matches a previously computed syndrome.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>