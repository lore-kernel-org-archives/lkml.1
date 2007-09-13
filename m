Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbXIMRUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbXIMRUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXIMRUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:20:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45018 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXIMRUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:20:46 -0400
Date: Thu, 13 Sep 2007 19:22:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: Bernd Petrovitsch <bernd@firmix.at>,
       Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Message-ID: <20070913172210.GA26864@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at> <pan.2007.09.12.17.30.59.597440@gmail.com> <1189620186.31502.96.camel@tara.firmix.at> <46E84208.1050903@leemhuis.info> <20070912200348.GA19434@uranus.ravnborg.org> <46E96EBE.8030108@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E96EBE.8030108@leemhuis.info>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 07:09:18PM +0200, Thorsten Leemhuis wrote:
> Hi Sam!
> 
> On 12.09.2007 22:03, Sam Ravnborg wrote:
> >> I think the Fedora approach has many benefits -- I always wondered why
> >> it never went upstream like a "make install_develstuff" that install all
> >> the needed bits to
> >>   /lib/modules/$(uname -r)/build/
> > Last time I saw the patch is was to ugly to consider.
> 
> Do you have a pointer to that patch?
See: http://lkml.org/lkml/2007/9/12/331

Chris Wedgwood posted it today.

	Sam
