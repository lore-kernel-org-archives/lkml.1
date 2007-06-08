Return-Path: <linux-kernel-owner+w=401wt.eu-S1032265AbXFHWJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032265AbXFHWJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970269AbXFHWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:09:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52932 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970173AbXFHWJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:09:29 -0400
Date: Sat, 9 Jun 2007 00:10:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Tom <fivemiletom@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RE : Building kernel 2.6.21.3 for arm on cygwin
Message-ID: <20070608221032.GA26637@uranus.ravnborg.org>
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org> <46697C5E.9060607@parrot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46697C5E.9060607@parrot.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu.

Can you please try to tell what your patch actually does.

As for the part added in the MAkefile you pass -lintl for Cygwin -
but I fail to see _why_ -lintl is needed.

The patch to check-lxdialog.sh is outdated.
Could I ask you to redo it againt latest version and again explains
the _why_ part. The how part is obvious from the diff...

Do not get me worg. I would love to have Cygwin supported but I want
it in the cleanest possible way.

	Sam
