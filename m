Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYJRIqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYJRIqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJRIqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:46:10 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33268 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752100AbYJRIqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:46:08 -0400
Date: Sat, 18 Oct 2008 10:45:56 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Samuel Ortiz <sameo@openedhand.com>,
       lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [rtc-linux] [patch 2/3] rtc-twl4030 driver
Message-ID: <20081018104556.54099e08@i1501.lan.towertech.it>
In-Reply-To: <200810171915.08290.david-b@pacbell.net>
References: <200810171915.08290.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 19:15:08 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> This adds a driver for the RTC inside the TWL4030 multi-function device.
> It's a fairly basic RTC, with a wake-capable alarm.
> 
> Note that many of the pre-release Overo boards now in circulation can't
> effectively use this RTC, because of a wiring error that puts its TWL
> chip into "secure" mode.  (As in "secure yourself against tampering".)
> This isn't an issue on other OMAP3 boards now supported in mainline,
> such as Beagle and Labrador.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

 I'd love to see an email in MODULE_AUTHOR
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

