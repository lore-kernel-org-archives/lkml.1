Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZIULnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZIULnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZIULne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:43:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38260 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZIULne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:43:34 -0400
Date: Mon, 21 Sep 2009 12:42:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2] arm: export "W" macro just for assembly code
Message-ID: <20090921114231.GA30821@n2100.arm.linux.org.uk>
References: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com> <20090918193422.GA6601@n2100.arm.linux.org.uk> <20090920194012.GA22062@Chamillionaire.breakpoint.cc> <1253533288.1541.87.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253533288.1541.87.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 12:41:28PM +0100, Catalin Marinas wrote:
> On Sun, 2009-09-20 at 21:40 +0200, Sebastian Andrzej Siewior wrote:
> > Russel, I've added a new patch description for this patch since my
> > rename edition was a little larger.
> 
> I already added a patch with the modified description in my for-rmk
> branch. I'm not sure Russell had time to pull it.

It got pulled before you modified it, so we're going to have to live
with it with its silly description now.
