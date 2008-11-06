Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYKFTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYKFTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYKFTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:21:07 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52164 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbYKFTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:21:05 -0500
Date: Thu, 6 Nov 2008 14:20:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Peter Alfredsen <loki_val@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lee Howard <lee.howard@mainpine.com>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081106192046.GH18939@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	Peter Alfredsen <loki_val@gentoo.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Lee Howard <lee.howard@mainpine.com>, linux-kernel@vger.kernel.org
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106191250.GA28514@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 07:12:50PM +0000, Russell King wrote:
> It was based upon the original serial.c by Ted T'so, but with some
> reworking to add a separate quirks table, and quite a number of cleanups.
> 
> My personal position is that code I author is GPLv2, and not GPLv2 or
> later.  So it's a question whether you consider that I'm the author
> of the code in that file, or whether you think it's Ted's with my
> contributions were under Ted's original terms.

My personal opinion has also always been GPLv2, and not GPLv2 or
later.  So I'm a bit puzzled as to where the GPLV2+ language came
from....

						- Ted
