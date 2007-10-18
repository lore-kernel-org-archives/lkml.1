Return-Path: <linux-kernel-owner+w=401wt.eu-S1763284AbXJRLPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763284AbXJRLPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbXJRLPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:15:33 -0400
Received: from ns.suse.de ([195.135.220.2]:34921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794AbXJRLPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:15:33 -0400
Date: Thu, 18 Oct 2007 13:15:30 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
Message-ID: <20071018111530.GA10028@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
References: <20071016162857.635479952@strauss.suse.de> <20071016162858.545617122@strauss.suse.de> <20071017110550.GB17565@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017110550.GB17565@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-10-17 13:05]:
> 
> 
> I think we should unreserve the chunks of memory we have reserved so
> far (Memory reserved from sidx to i), in case of error.

True. Next version is coming.


Thanks,
   Bernhard
