Return-Path: <linux-kernel-owner+w=401wt.eu-S1763245AbXHCRep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763245AbXHCRep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXHCReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:34:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48251 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbXHCReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:34:36 -0400
Date: Fri, 3 Aug 2007 13:31:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: RFC: UML: remove MODE_TT?
Message-ID: <20070803173154.GB8286@c2.user-mode-linux.org>
References: <20061212233533.GB28443@stusta.de> <20061213041837.GA8825@ccure.user-mode-linux.org> <20070728154705.GB30976@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728154705.GB30976@stusta.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 05:47:05PM +0200, Adrian Bunk wrote:
> MODE_TT is still marked as broken and still not compiling...
> 
> Will anyone fix it or can it finally be removed?

I guess it should finally be removed...

I have a patch which does that - I'll see how easily it moves to the
bottom of my patchset.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
