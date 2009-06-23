Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZFWOv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZFWOv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbZFWOvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:51:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbZFWOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:51:20 -0400
Date: Tue, 23 Jun 2009 10:50:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: liqin.chen@sunplusct.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: S+core architecture (arch/score/) support files
Message-ID: <20090623145059.GA6478@infradead.org>
References: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:37:07PM +0800, liqin.chen@sunplusct.com wrote:
> Hi Linus,
> 
> This repository contains Linux support for S+core CPU.
> 
> Please pull
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git score
> 
> Changes in v3:
> Sending pull request again.
> 
> Changes in v2:
> Christoph Hellwig and Arnd review it.

Still doesn't seem to be quite uptodate in the ptrace area, e.g. not
using regsets at all.  It would be really helpful if the final ptrace
code could be ran past Roland McGrath as the ptrace maintainer.

