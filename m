Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZKTPQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZKTPQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZKTPQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:16:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZKTPQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:16:31 -0500
Date: Fri, 20 Nov 2009 15:16:13 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: akpm@linux-foundation.org, tbm@cyrius.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Add support for LZMA-compressed kernel images
Message-ID: <20091120151613.GA26285@flint.arm.linux.org.uk>
References: <1258729323-16318-1-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258729323-16318-1-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 04:02:03PM +0100, Albin Tonnerre wrote:
> This patch allows using a kernel image compressed with LZMA on ARM,
> using the support for multiple decompressors introduced in the LZO
> support patch.
> Extracting the image is fairly slow, but it might be useful on machines
> with a very limited amount of storage.

I didn't see a response to my previous message about the LZO patch set.
Do you want me to queue up the patch set for the next merge window?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
