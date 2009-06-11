Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZFKHK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZFKHK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZFKHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:10:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:25277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbZFKHKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,201,1243839600"; 
   d="scan'208";a="153045507"
Subject: [RFC 0/7] crypto: PCLMULQDQ accelerated GHASH
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Jun 2009 15:10:23 +0800
Message-Id: <1244704223.5320.123.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Herbert,

This patchset adds PCLMULQDQ accelerated GHASH. Because conversion from
crypto_hash to crypto_shash has not been done, this patchset is not
intended to be merged now.

Please take a look at the general design.

Best Regards,
Huang Ying

