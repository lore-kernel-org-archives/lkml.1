Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXJSMl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXJSMl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbXJSMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:41:19 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:32085 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbXJSMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:41:18 -0400
Date: Fri, 19 Oct 2007 14:40:25 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: rename iommu.h to gart.h
Message-ID: <20071019124025.GD4361@rhun.haifa.ibm.com>
References: <1192797491473-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192797491473-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 02:38:11PM +0200, Joerg Roedel wrote:

> This patch renames the include file asm-x86/iommu.h to asm-x86/gart.h to make
> clear to which IOMMU implementation it belongs. The patch also adds "GART" to
> the Kconfig line.

Long overdue IMHO. How about also renaming the config option to
CONFIG_GART_IOMMU while you're at it?

Cheers,
Muli
-- 
SYSTOR 2007 --- 1st Annual Haifa Systems and Storage Conference 2007
http://www.haifa.il.ibm.com/Workshops/systor2007/

Virtualization workshop: Oct 29th, 2007 | Storage workshop: Oct 30th, 2007
