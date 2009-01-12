Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZALV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZALV1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZALV1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:27:13 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39517 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbZALV1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:27:13 -0500
Date: Mon, 12 Jan 2009 22:28:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Can we get warnings from the x86 userspace headers fixed?
Message-ID: <20090112212855.GB15185@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

We have recently introduced a lot of new warnings for our
userspace headers.

Try to do a "make headers_check" and enjoy...

Are there any chance you could ask one of your helpers to
start to look into the x86 specific ones?

If we get x86 clean this would create more incentive to
make the generic clean too.

I had originally planned to attack the generic headers
(include/linux/*) but I'm faced by reality after my
vacation and has almost no spare time for the time being.

I already fixed the sparc headers but that is not 
visible compared to x86 (the fixes was btw easy).

I can try to help by doing a few reviews in the
beginning but I need to fix kbuild stuff first where
I have a few serious issues pending. And lacks time...

	Sam

