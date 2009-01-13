Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZAMUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZAMUya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZAMUyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:54:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47316 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZAMUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:54:19 -0500
Date: Tue, 13 Jan 2009 21:54:17 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong usage of __devexit_p and __exit_p
Message-ID: <20090113205417.GA31956@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de> <20090112141457.GA11777@uranus.ravnborg.org> <20090112144327.GB29183@pengutronix.de> <20090112205520.GA10870@pengutronix.de> <20090112212109.GA15185@uranus.ravnborg.org> <20090112221500.GA24895@pengutronix.de> <20090113053709.GA19426@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113053709.GA19426@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

> > > You already convinced me with your first mail that you had checked
> > > that the functions was not used for anything else then the exit path.
> > So I can interpret this as a general Acked-by:?
> 
> Yes.
The complete (topgit-controlled) series is now available at

	git://git.pengutronix.de/git/ukl/linux-2.6.git expsec-master

with your Acked-by.

Up to now I didn't get any feedback apart from your's. Maybe I need to
find the right people to Cc: myself. :-|

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
