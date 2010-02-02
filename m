Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0BBBEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:04:20 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:46476 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570Ab0BBBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:04:18 -0500
Message-ID: <4B6779FE.3090408@snapgear.com>
Date: Tue, 02 Feb 2010 11:03:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/6] generic sys_old_select
References: <20100201185506.GA11045@lst.de>
In-Reply-To: <20100201185506.GA11045@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Add a generic implementation of the old select syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the m68knommu parts

Acked-by: Greg Ungerer <gerg@uclinux.org>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
