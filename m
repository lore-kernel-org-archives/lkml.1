Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYFUWLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYFUWLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYFUWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:10:53 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59094 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYFUWKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:10:52 -0400
Date: Sun, 22 Jun 2008 00:11:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Support arch/$ARCH/include in kbuild
Message-ID: <20080621221137.GD12279@uranus.ravnborg.org>
References: <20080621220703.GA12279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621220703.GA12279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Patches are on top of kbuild-next.git and follows.

Just to make it crystal clear.
These patches are for comment and I will await feedback before
pushing to kbuild-next.git (and thus -next).


And archs are not forced to move their header files now.
They can wait until it fits their schedule.

	Sam
