Return-Path: <linux-kernel-owner+w=401wt.eu-S1764356AbXIKVEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764356AbXIKVEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXIKVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:03:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42512 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXIKVDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:03:52 -0400
Date: Tue, 11 Sep 2007 23:05:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070911210516.GA10160@uranus.ravnborg.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <20070911203412.GS3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911203412.GS3563@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As an example, visws.c is as much non-64bit as it is pre-i686.
Bad example...
visws is a visws specific file that should naver have allowed
anywhere outside mach-visws.
Any link-order issues should have been dealt with in other ways.

	Sam
