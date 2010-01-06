Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732Ab0AFLR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0AFLR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671Ab0AFLR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:17:26 -0500
Received: from poutre.nerim.net ([62.4.16.124]:52074 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0AFLRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:17:25 -0500
Date: Wed, 6 Jan 2010 12:17:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] pca953x: Minor include cleanup
Message-ID: <20100106121722.6e2598ec@hyperion.delvare>
In-Reply-To: <20100105202158.GB4848@pengutronix.de>
References: <20100105201042.GA28367@lixom.net>
	<20100105202158.GB4848@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 21:21:58 +0100, Wolfram Sang wrote:
> On Tue, Jan 05, 2010 at 02:10:42PM -0600, Olof Johansson wrote:
> > linux/i2c/pca953x.h is a very bare include file. Fix check for multiple
> > includes of linux/i2c/pca953x.h, and add dependent includes into the
> > header file.
> > 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

And also

Acked-by: Jean Delvare <khali@linux-fr.org>

Note though that this file is not part of the i2c subsystem. Your patch
is something for the gpio people.

-- 
Jean Delvare
