Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZKTPXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZKTPXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZKTPXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:23:24 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:57319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZKTPXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:23:24 -0500
Date: Fri, 20 Nov 2009 16:23:24 +0100
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, tbm@cyrius.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Add support for LZMA-compressed kernel images
Message-ID: <20091120152324.GD11847@pc-ran3241.res.insa>
References: <1258729323-16318-1-git-send-email-albin.tonnerre@free-electrons.com>
 <20091120151613.GA26285@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20091120151613.GA26285@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 15:16 +0000, Russell King wrote :
> On Fri, Nov 20, 2009 at 04:02:03PM +0100, Albin Tonnerre wrote:
> > This patch allows using a kernel image compressed with LZMA on ARM,
> > using the support for multiple decompressors introduced in the LZO
> > support patch.
> > Extracting the image is fairly slow, but it might be useful on machines
> > with a very limited amount of storage.
> 
> I didn't see a response to my previous message about the LZO patch set.
> Do you want me to queue up the patch set for the next merge window?

Oh, sorry, I must have missed it. I would indeed appreciate this, thank you very
much.

Regards,
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
