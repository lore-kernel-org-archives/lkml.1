Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXEJVSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXEJVSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbXEJVSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:18:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44420 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbXEJVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:18:38 -0400
Date: Thu, 10 May 2007 23:19:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510211933.GC23149@uranus.ravnborg.org>
References: <20070510203417.GA23019@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510203417.GA23019@tuatara.stupidest.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:34:18PM -0700, Chris Wedgwood wrote:
> MODPOST seems to be spewing bogus warnings.  It's not clear how best
> to fix it so perhaps we should silence it for now?
> 

There is a number of know bogus warnings being looked at.
Could you please post the ones you have in mind so we can see if this is
know ones or new (bogus)? warnings.

PS. I count at least 30 section mismatch warnings being fixed in the kernel lately.
So the check has an effect.

	Sam
