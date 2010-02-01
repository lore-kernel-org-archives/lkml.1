Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0BAW15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:27:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54997 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0BAW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:27:55 -0500
Message-ID: <4B675379.80807@zytor.com>
Date: Mon, 01 Feb 2010 14:19:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       gerg@uclinux.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/6] generic sys_old_mmap
References: <20100201185524.GB11045@lst.de>
In-Reply-To: <20100201185524.GB11045@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a generic implementation of the old mmap syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.

Looks good to me from an x86 perspective.

Reviewed-by: H. Peter Anvin <hpa@zytor.com>
