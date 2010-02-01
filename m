Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0BAXic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:38:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46927 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0BAXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:38:30 -0500
Date: Mon, 1 Feb 2010 23:38:13 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/6] generic sys_old_mmap
Message-ID: <20100201233813.GF21693@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
	ysato@users.sourceforge.jp, tony.luck@intel.com,
	geert@linux-m68k.org, zippel@linux-m68k.org, gerg@uclinux.org,
	schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
	jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, viro@zeniv.linux.org.uk
References: <20100201185524.GB11045@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201185524.GB11045@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 07:55:24PM +0100, Christoph Hellwig wrote:
> Add a generic implementation of the old mmap syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.

Looks fine to me.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
