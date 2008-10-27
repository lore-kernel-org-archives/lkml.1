Return-Path: <linux-kernel-owner+w=401wt.eu-S1751539AbYJ0R1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbYJ0R1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYJ0R1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:27:07 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33669 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751735AbYJ0R1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:27:06 -0400
Date: Mon, 27 Oct 2008 18:26:54 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: broonie@sirena.org.uk, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for
 WM8350 RTC
Message-ID: <20081027182654.7495be2b@i1501.lan.towertech.it>
In-Reply-To: <20081027172359.GJ5896@sirena.org.uk>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20081027180432.7deaee0a@i1501.lan.towertech.it>
	<20081027172359.GJ5896@sirena.org.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 17:24:01 +0000
Mark Brown <broonie@sirena.org.uk> wrote:

> 
> On Mon, Oct 27, 2008 at 06:04:32PM +0100, Alessandro Zummo wrote:
> 
> > > +	.resume = wm8350_rtc_resume,
> > > +	.driver = {
> > > +		.name = "wm8350-rtc",
> 
> >  I'd like rtc-wm8350 here, if it doesn't hurt anything else.
> 
> Due to needing to go through the MFD tree as well it'd make life easier
> if we could leave as-is and avoid creating any merging issues (it's also
> consistent with all the other WM8350 drivers).  Would that be OK?

 Ok, leave it that way: that's classified as "hurting" :)


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

