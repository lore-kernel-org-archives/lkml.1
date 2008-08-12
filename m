Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYHLFLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYHLFLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYHLFK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:10:57 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:37125 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYHLFK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:10:56 -0400
Date: Tue, 12 Aug 2008 07:11:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] h8300 move header files
Message-ID: <20080812051101.GA21095@uranus.ravnborg.org>
References: <871w0wvgng.wl%ysato@users.sourceforge.jp> <20080811170534.22f26b7e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811170534.22f26b7e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This patch will cause me some pain, because people will occasionally
> change those headers and the plain-old-patch will break.
> 
> Some better options are
> 
> a) merge it into Sam's git tree, then he merges it into 2.6.28-rc1
> 
> b) you resend the pull request into Linus during the 2.6.28-rc1 merge window
> 
> c) merge it into mainline immediately
> 
> Sam, any suggestions here?

c) is preferred so we get this done for as soon as possible.
And this is a pure file move so it is simple.

If you do not have a git tree then just ask Linus to move the header
files.

	Sam
