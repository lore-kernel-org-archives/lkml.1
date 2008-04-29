Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYD2Qoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYD2Qoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYD2Qo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:44:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57300 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbYD2Qo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:44:28 -0400
Date: Tue, 29 Apr 2008 18:45:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Timur Tabi <timur@freescale.com>
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080429164501.GA18018@uranus.ravnborg.org>
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48173607.6080307@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I read in the latest Linux Journal magazine that someone noticed that even
> though the kernel scripts say #!/bin/sh, many of them are really bash scripts.
> This person went through the effort of changing the script to be true 'sh'
> scripts.  Has that code been merged in?

I have no patches pending but I may have lost them.
As I am 100% ignorant about what is bash and what is not bash specialities
I will more or less be blind when I apply them so I hope they are well
tested.

	Sam
