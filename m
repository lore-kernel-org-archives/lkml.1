Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbYBANip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbYBANip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYBANih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:38:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58234 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYBANig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:38:36 -0500
Date: Fri, 1 Feb 2008 14:38:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: isdn4linux@listserv.isdn4linux.de
Subject: [PATCH 0/5] isdn: fix section mismatch warnings in isdn
Message-ID: <20080201133838.GA13349@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn resulted in 34 section mismatch warnings - so
I decided to give them a try.
This resulted in 5 simple patches.

I know Jeff Garzik has some ISDN clean-up patches pending
but rather than waiting forever to have them acked I deciced
to fix the warnings in the current kernel.

This for no other reason than to get the noise level down.

Andrew - I expect you to pick them up in -mm and forward to Linus.

	Sam
