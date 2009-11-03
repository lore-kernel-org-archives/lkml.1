Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZKCQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZKCQEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZKCQEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:04:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZKCQEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:04:47 -0500
Date: Tue, 3 Nov 2009 17:04:51 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: "move stk17ta8's probe function to .devinit.text" considered
	trivial?
Message-ID: <20091103160451.GA21647@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just noticed that my patch

	move stk17ta8's probe function to .devinit.text

is in your trivial queue (as c4fd30f9).  I'm happy that you took that,
but I wonder if this is really trivial material considering that some of
these patches were nacked.

If you still think it's trivial you can take my other ~35 patches doing
the same for other drivers.

At some point Greg signaled that he would take the series but he seems
too much buried in other work. :-/

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
