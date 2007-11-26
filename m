Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbXKZBL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbXKZBL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXKZBLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:11:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:56042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbXKZBLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:11:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,464,1188802800"; 
   d="scan'208";a="402316428"
Subject: Re: [PATCH] iwlwifi: remove redundant declaration of
	'iwl3945_priv' and 'iwl4965_priv' structs
From: Zhu Yi <yi.zhu@intel.com>
To: Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <200711251558.07511.mboton@gmail.com>
References: <200711251558.07511.mboton@gmail.com>
Content-Type: text/plain; charset=GB2312
Organization: Intel Corp.
Date: Mon, 26 Nov 2007 09:10:23 +0800
Message-Id: <1196039423.3250.570.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-25 at 15:58 +0100, Miguel Bot¨®n wrote:
> This patch removes a redundant declaration of 'iwl3945_priv' and
> 'iwl4965_priv' structs.
> 
> Signed-off-by: Miguel Boton <mboton@gmail.com>

ACK.

Thanks,
-yi
