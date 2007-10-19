Return-Path: <linux-kernel-owner+w=401wt.eu-S966384AbXJSJIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966384AbXJSJIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966755AbXJSJHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:07:53 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4013 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965782AbXJSJHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:07:52 -0400
Date: Fri, 19 Oct 2007 11:07:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: bryan.wu@analog.com, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Blackfin I2C/TWI driver: update for 2.6.24 merge
 windows
Message-ID: <20071019110750.33f66dd8@hyperion.delvare>
In-Reply-To: <386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com>
References: <1192456403.6215.5.camel@roc-laptop>
	<386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Thu, 18 Oct 2007 14:11:35 +0800, Bryan Wu wrote:
> Could you kindly review this patch?

I'm pretty busy these days, I don't have much spare time for reviews.

BTW, as a rule of thumb, I am ignoring patches that are sent to the
LKML in addition to the i2c list. If you think that your patch is so
important that it has to be send to a list with over 4500 subscribers
that sees 120.000 messages each year, then who am I to dare to comment
on it?

If you want me to consider your patches as something that needs my
attention, send them to the i2c list only, do not add LKML. This is
general advice for everyone sending i2c patches, not just you, of
course.

Back to your patch... Originally you posted two patches, and I see that
they are now merged into a single patch, why? It's much better to have
separate patches, it makes reviews and testing way easier. If you
provide separate patches I'll try to find some time to review them.

Note that this won't be for 2.6.24 anyway, it's too late for that, I've
already sent my i2c patches to Linus. From now on, only bugfixes can go
in 2.6.24, improvements will have to wait for 2.6.25.

-- 
Jean Delvare
