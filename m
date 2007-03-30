Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXC3TCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXC3TCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXC3TCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:02:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:37632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXC3TCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,354,1170662400"; 
   d="scan'208"; a="66566188:sNHT19713447"
Subject: Re: [PATCH 2.6.20.4]
From: Mitch Williams <mitch.a.williams@intel.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, auke-jan.h.kok@intel.com
In-Reply-To: <1175280965.17652.8.camel@strongmad>
References: <1175280965.17652.8.camel@strongmad>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 12:02:43 -0700
Message-Id: <1175281363.17652.13.camel@strongmad>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 11:56 -0700, Mitch Williams wrote:
> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
> 
Grrr.  Evolution cut-n-sometimes-paste feature bit me.  Will resend with
a proper subject line.
-Mitch
