Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZGNCAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZGNCAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZGNCAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:00:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:39767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZGNCAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:00:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,394,1243839600"; 
   d="scan'208";a="429963997"
From: "Zhu, Yi" <yi.zhu@intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>,
       "drzeus-list@drzeus.cx" <drzeus-list@drzeus.cx>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Winkler, Tomas" <tomas.winkler@intel.com>
Date: Tue, 14 Jul 2009 09:59:43 +0800
Subject: RE: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
Thread-Topic: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
Thread-Index: AcoEBr6bZDmxWDU3Rl6EGe2X8kGjywAH7suQ
Message-ID: <AFAB8585072C7E48BC5C6F9C87F9B79703BA8388BB@pdsmsx502.ccr.corp.intel.com>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
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

Tomas wrote:

> +#define SDIO_VENDOR_ID_INTEL			0x0089
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200WIFI	0x1403
> +#define SDIO_DEVICE_ID_INTEL_IWMC3200TOP        0x1404

Looks good. Please replace the above spaces with a TAB.

> +#define SDIO_DEVICE_ID_INTEL_IWMC3200BT		0x1406
> 
>  #define SDIO_VENDOR_ID_MARVELL			0x02df
>  #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103

Thanks,
-yi
