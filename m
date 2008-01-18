Return-Path: <linux-kernel-owner+w=401wt.eu-S1764840AbYARV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764840AbYARV4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYARV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:56:05 -0500
Received: from mail0.scram.de ([78.47.204.202]:57530 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYARV4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:56:03 -0500
X-Spam-Score: -4.058
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47912088.4040507@scram.de>
Date: Fri, 18 Jan 2008 22:56:24 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH/RFCv2] [POWERPC] Add support for freescale watchdog to
 CPM serial driver.
References: <478F4AE3.5090803@scram.de> <20080118183905.2d5d8474@lxorguk.ukuu.org.uk> <4790F44F.8020009@scram.de> <20080118204030.48fbb683@lxorguk.ukuu.org.uk> <EC416CBA-9200-4D71-8D95-39798937203D@kernel.crashing.org>
In-Reply-To: <EC416CBA-9200-4D71-8D95-39798937203D@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

>> Ok now that makes sense, thanks
> 
> So I'll ask, what serial input are you waiting for from the boot wrapper?

It's the editor for the kernel command line.

Thanks,
Jochen
