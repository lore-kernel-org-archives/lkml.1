Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZKCQ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZKCQ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZKCQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:26:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55644 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZKCQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:26:08 -0500
Date: Tue, 3 Nov 2009 17:26:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: "move stk17ta8's probe function to .devinit.text" considered
	trivial?
Message-ID: <20091103162612.GB21647@pengutronix.de>
References: <20091103160451.GA21647@pengutronix.de> <alpine.LSU.2.00.0911031705370.9988@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.00.0911031705370.9988@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

On Tue, Nov 03, 2009 at 05:07:12PM +0100, Jiri Kosina wrote:
> This one was Acked by the maintainer of the driver, therefore it is OK to 
> take it through trivial tree, see the trivial patch monkey guidelines in 
> Documentation/SubmittingPatches.
Ah, OK, that's new to me.

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
