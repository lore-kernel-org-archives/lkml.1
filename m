Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXDLUhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXDLUhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXDLUhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:37:33 -0400
Received: from ns.suse.de ([195.135.220.2]:53783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbXDLUhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:37:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Subject: Re: [KJ][PATCH 03/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Date: Thu, 12 Apr 2007 22:37:20 +0200
User-Agent: KMail/1.9.6
Cc: kernel-janitors@lists.osdl.org, linux-ia64@vger.kernel.org,
       discuss@x86-64.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tony.luck@intel.com
References: <20070412203205.GC9353@arun.site>
In-Reply-To: <20070412203205.GC9353@arun.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122237.20779.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 22:32:05 Milind Arun Choudhary wrote:
> ROUND_UP macro cleanup in arch/x86_64
> ALIGN, ALIGN_DOWN  where ever appropriate.

Sorry, but I prefer round_up/round_down in x86-64 code.

-Andi
