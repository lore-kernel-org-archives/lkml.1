Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbYAWLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbYAWLYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYAWLYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:24:40 -0500
Received: from mail0.scram.de ([78.47.204.202]:53576 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYAWLYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:24:39 -0500
X-Spam-Score: -4.18
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <479723CE.5020609@scram.de>
Date: Wed, 23 Jan 2008 12:23:58 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jon Smirl <jonsmirl@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2
  controllers
References: <477BEB60.4070703@scram.de>	<20080103104121.58697148.sfr@canb.auug.org.au> <20080123112941.23250948@hyperion.delvare>
In-Reply-To: <20080123112941.23250948@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Do you have an updated patch addressing Stephen's comment?
> 
> Note: you'd rather send updates of this patch to the i2c list rather
> than LKML.

I'm currently looking at that last patches from Jon and try to make this
driver fit in there (+ the class override stuff).

Note: will do. I just subscribed to this list.

Thanks,
Jochen
