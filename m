Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXILUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXILUEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXILUEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:04:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48332 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbXILUEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:04:43 -0400
Date: Wed, 12 Sep 2007 22:03:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Cc: Bernd Petrovitsch <bernd@firmix.at>,
       Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Message-ID: <20070912200348.GA19434@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at> <pan.2007.09.12.17.30.59.597440@gmail.com> <1189620186.31502.96.camel@tara.firmix.at> <46E84208.1050903@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E84208.1050903@leemhuis.info>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi knurd.

> I think the Fedora approach has many benefits -- I always wondered why
> it never went upstream like a "make install_develstuff" that install all
> the needed bits to
>   /lib/modules/$(uname -r)/build/

Last time I saw the patch is was to ugly to consider.
Now that is maybe a year ago and I would be happy to take another look
should someone submit it to me.

	Sam
