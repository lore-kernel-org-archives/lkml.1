Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbXERJVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbXERJVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbXERJU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:20:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42201 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbXERJU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:20:56 -0400
Date: Fri, 18 May 2007 11:21:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/14] kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings
Message-ID: <20070518092153.GB12551@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org> <20070518065352.GF12284@uranus.ravnborg.org> <jefy5uec5e.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jefy5uec5e.fsf@sykes.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:03:57AM +0200, Andreas Schwab wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
> > + * The follwoing markers are used for the cases where the reference to
> 
> s/follwoing/following/
> 
> Andreas.

Thnaks, fixed locally.

	Sam
