Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbZANOdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbZANOdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZANOc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:32:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:64449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZANOc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:32:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,263,1231142400"; 
   d="scan'208";a="481594382"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Date: Wed, 14 Jan 2009 14:32:39 +0000
Subject: RE: [PATCH] dmatest: Use custom map/unmap for destination buffer
Thread-Topic: [PATCH] dmatest: Use custom map/unmap for destination buffer
Thread-Index: Acl1lHjH196Pg5seSCqJ3A3xQvh/egAwDN2g
Message-ID: <129600E5E5FB004392DDC3FB599660D70CAAE436@irsmsx504.ger.corp.intel.com>
References: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1231860880-6277-1-git-send-email-anemo@mba.ocn.ne.jp>
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

Atsushi Nemoto wrote:
> The dmatest driver should use DMA_BIDIRECTIONAL on the destination
> buffer
> to ensure that the poison values are written to RAM and not just
> written
> to cache and discarded.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
