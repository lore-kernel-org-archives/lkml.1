Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945Ab0A0SAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0A0SAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 13:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861Ab0A0SAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 13:00:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab0A0SAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 13:00:37 -0500
Date: Wed, 27 Jan 2010 18:00:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: spitz (arm pda): time no longer ok after resume
Message-ID: <20100127180010.GA22660@n2100.arm.linux.org.uk>
References: <20100127171308.GA24875@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127171308.GA24875@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 06:13:08PM +0100, Pavel Machek wrote:
> It seems that spitz has problems with time after resume; time while it
> was sleeping is not accounted. This seems to be regression in
> 2.6.33-rc5.

No rtc configured/loaded?
