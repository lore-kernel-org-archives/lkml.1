Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXJXBY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXJXBY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXJXBYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:24:17 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:59705 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbXJXBYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:24:15 -0400
Date: Tue, 23 Oct 2007 21:06:31 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/4] x86 gart: rename CONFIG_IOMMU to CONFIG_GART_IOMMU
Message-ID: <20071023190631.GD4360@rhun.haifa.ibm.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <11931612931391-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11931612931391-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:41:31PM +0200, Joerg Roedel wrote:
> This patch renames the IOMMU config option to GART_IOMMU because in fact it
> means the GART and not general support for an IOMMU on x86.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
