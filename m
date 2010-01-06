Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086Ab0AFW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0AFW1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940Ab0AFW1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:27:20 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:53830 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0AFW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:27:20 -0500
Date: Wed, 6 Jan 2010 23:27:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, jdike@addtoit.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/3] generic sys_old_mmap
Message-ID: <20100106222716.GA11394@osiris.boeblingen.de.ibm.com>
References: <20100106172135.GB17163@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172135.GB17163@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 06:21:35PM +0100, Christoph Hellwig wrote:
> Add a generic implementation of the old mmap syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.

No compat version here?
