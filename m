Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXGQBwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXGQBwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbXGQBv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:51:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:32687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXGQBvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,544,1175497200"; 
   d="scan'208";a="269154775"
Subject: Re: [PATCH] ACPI: Add reboot mechanism
From: Shaohua Li <shaohua.li@intel.com>
To: Aaron Durbin <adurbin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Brown, Len" <len.brown@intel.com>, ak@suse.de, akpm@osdl.org
In-Reply-To: <20070716180019.GA5112@google.com>
References: <20070716180019.GA5112@google.com>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 09:46:56 +0800
Message-Id: <1184636816.11983.1.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 02:00 +0800, Aaron Durbin wrote:
> 
> Add the ability to reset the machine using the RESET_REG in ACPI's
> FADT table.
We could have another command for 'reboot' kernel command line.

Thanks,
Shaohua
