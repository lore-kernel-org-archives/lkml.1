Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXGPHPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXGPHPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXGPHOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:14:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXGPHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R6puHmednHGgHKLKPU7AEE0Pr6VOIaplfc1wXyrZSjmy3jq5tBQT4zPqxcvwG8u9w4IiiQhl7WLUzcTyzaWWGZ09SuJYPINCDEGf2ZfBFwtRhe0Nt5jwJvHo0+F3mf0p2RlypzyHygznzOW83tzP3ppwHdYu5HCwBDJMSaSLC5k=
Message-ID: <5d5443650707160014g7b1bec24uf2c89837fd6fc538@mail.gmail.com>
Date: Mon, 16 Jul 2007 12:44:50 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [i2c] OMAP: Add TI TWL92330/Menelaus Power Management chip driver
Cc: i2c@lm-sensors.org, "Jean Delvare" <khali@linux-fr.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tony Lindgren" <tony@atomide.com>,
       "David Brownell" <david-b@pacbell.net>, amit.kucheria@gmail.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
In-Reply-To: <Pine.LNX.4.60.0707150104050.12464@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
	 <Pine.LNX.4.60.0707150104050.12464@poirot.grange>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On 7/15/07, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Tue, 10 Jul 2007, Trilok Soni wrote:
>
> > Hi Jean/Andrew,
> >
> > Attached patch adds Texas Instruments TWL92330/Menelaus Power
> > Management chip driver. Also includes RTC code in the same driver
> > instead of the separate module. Here is the description of
> > driver/commit message :)
>
> I think, the plan is to eventually merge the power_supply class currently
> in -mm, so, it would be nice to interface menelaus to it?

Could you please point me to the exact name of that patch for
power_supply class in -mm?

-- 
--Trilok Soni
