Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbYKFRHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbYKFRHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYKFRHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:07:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:14929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbYKFRHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:07:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,558,1220252400"; 
   d="scan'208";a="400768194"
Subject: Re: iwlagn: wrong command queue 31, command id 0x0
From: reinette chatre <reinette.chatre@intel.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225944979.3792.3.camel@calx>
References: <1225944979.3792.3.camel@calx>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 09:07:35 -0800
Message-Id: <1225991255.1115.657.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 20:16 -0800, Matt Mackall wrote:
> As of 75fa67706cce5272bcfc51ed646f2da21f3bdb6e, I'm seeing this:
> 
> [ 5470.869820] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204
> iwl_rx_handle+0x11a/0x21b [iwlagn]()
> [ 5470.869824] wrong command queue 31, command id 0x0

This is a known issue that is being tracked at
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

Reinette

