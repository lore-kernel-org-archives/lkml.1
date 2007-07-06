Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbXGFAB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbXGFAB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXGFABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:01:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52124 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbXGFABP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:01:15 -0400
Message-ID: <468D8648.8030602@garzik.org>
Date: Thu, 05 Jul 2007 20:01:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 3/4] Enable link power management for ata drivers
References: <20070705194909.337398431@intel.com>	<20070705130530.5873afeb.kristen.c.accardi@intel.com>	<20070705153334.08402809.akpm@linux-foundation.org> <20070705153718.3aaf8ea5.akpm@linux-foundation.org>
In-Reply-To: <20070705153718.3aaf8ea5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I guess we can bump ATA_DFLAG_CFG_MASK up to 12, like this?

Yep

	Jeff



