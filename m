Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbZKXXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbZKXXSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934359AbZKXXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:18:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:20390 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934358AbZKXXSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:18:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="470300091"
Date: Wed, 25 Nov 2009 00:20:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Remove build time warning for WM835x register
 default tables
Message-ID: <20091124232029.GF8290@sortiz.org>
References: <>
 <1259061405-24442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259061405-24442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:16:45AM +0000, Mark Brown wrote:
> Systems using the WM835x need to choose which of the default register
> settings are required on the system.  Currently there is a compile time
> warning as well as a runtime error intended to flag up to users that
> this is required but this also triggers for people building the driver
> in order to obtain build coverage.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
