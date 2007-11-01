Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXKAR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXKAR5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXKAR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:57:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47107 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbXKAR5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:57:30 -0400
Date: Thu, 1 Nov 2007 18:59:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: kbuild problem
Message-ID: <20071101175907.GA3312@uranus.ravnborg.org>
References: <20071031183900.46a0b529.rdunlap@xenotime.net> <20071101052145.GA31445@uranus.ravnborg.org> <20071101101157.90e194d3.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101101157.90e194d3.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think I found it -- in my scripts.  :)
> They still think that $ARCH is i386 or x86_64, not "x86".
> I'm testing a fix for that now.

Good - thanks for reporting back.

	Sam
