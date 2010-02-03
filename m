Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0BCJmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:42:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab0BCJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:42:29 -0500
Date: Wed, 3 Feb 2010 10:42:26 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20100203094226.GD11354@pengutronix.de>
References: <20090619144354.GA20985@pengutronix.de> <20090629075535.GA20155@pengutronix.de> <20090711033459.GC1344@suse.de> <20090711100014.GA9540@pengutronix.de> <20090711170548.GC5205@suse.de> <20090907141941.GA19380@pengutronix.de> <20100122170641.GD13718@pengutronix.de> <20100122173846.GA11057@suse.de> <20100126085928.GD20792@pengutronix.de> <20100128180235.GE19871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100128180235.GE19871@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > So can you please look into that before they are swapped out of your
> > inbox the third(?) time?
> 
> I think the video ones can be all in one patch, that makes it easier for
> me to track and apply.  Same goes for any others you can merge together.
So I group by drivers/* and arch/*?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
