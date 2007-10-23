Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXJXBYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXJXBYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbXJXBYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:24:00 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:8370 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXJXBX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:23:59 -0400
Date: Tue, 23 Oct 2007 21:07:02 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 3/4] x86 gart: make some variables and functions static
Message-ID: <20071023190702.GE4360@rhun.haifa.ibm.com>
References: <11931612933917-git-send-email-joerg.roedel@amd.com> <11931612934125-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11931612934125-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:41:32PM +0200, Joerg Roedel wrote:
> This patch makes some functions and variables static in pci-gart_64.c which are
> not used somewhere else.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
