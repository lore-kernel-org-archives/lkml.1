Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbZAHTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbZAHTI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbZAHTII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:08:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49390
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbZAHTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:08:05 -0500
Date: Thu, 08 Jan 2009 11:08:07 -0800 (PST)
Message-Id: <20090108.110807.103950637.davem@davemloft.net>
To: inaky@linux.intel.com
Cc: netdev@vger.kernel.org, wimax@linuxwimax.org, greg@kroah.com,
       randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wimax@intel.com
Subject: Re: [PATCH 3/4] wimax: testing for rfkill support should also test
 for CONFIG_RFKILL_MODULE
From: David Miller <davem@davemloft.net>
In-Reply-To: <ce4d7f71df1471d502e02861a7db65cbb2a5548f.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
	<ce4d7f71df1471d502e02861a7db65cbb2a5548f.1231355768.git.inaky@linux.intel.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date: Wed,  7 Jan 2009 11:22:21 -0800

> Current WiMAX rfkill code is missing the case where rfkill is compiled
> in as modules and works only when rfkill is compiled in. This is not
> correct. Fixed to test for CONFIG_RFKILL or CONFIG_RKILL_MODULE.
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Applied.
