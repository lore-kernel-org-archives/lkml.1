Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYECIBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYECIBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYECIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:01:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35160 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYECIBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:01:19 -0400
Date: Sat, 3 May 2008 10:01:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: SL Baur <steve@xemacs.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Timur Tabi <timur@freescale.com>,
       Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
Subject: Re: cross-compiling on OS X, make menuconfig fails
Message-ID: <20080503080153.GA12970@uranus.ravnborg.org>
References: <481529B6.6030802@freescale.com> <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com> <20080429164535.GB18018@uranus.ravnborg.org> <20080429172057.GN5882@ZenIV.linux.org.uk> <20080429180601.GA19652@uranus.ravnborg.org> <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This looks O.K.  As a note, whatever behavior is being described here
> is system dependent, because on my installation of that other OS, `echo -e'
> works fine whether it is invoked as /bin/bash or /bin/sh which appears to be
> a strict copy of /bin/bash.
> 
> $ uname -v
> Darwin Kernel Version 8.11.1: Wed Oct 10 18:23:28 PDT 2007;
> root:xnu792.25.20~1/RELEASE_I386
> 
> Reviewed-by: SL Baur <steve@xemacs.org>

Thanks for your feedback.
The patch is already upstream so I unfortunately 
cannot add your Reviewed-by: tag.

	Sam
