Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbYDKTWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbYDKTWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760837AbYDKTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:22:19 -0400
Received: from mail0.scram.de ([78.47.204.202]:39122 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbYDKTWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:22:18 -0400
X-Spam-Score: -4.086
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47FFBABA.9040309@scram.de>
Date: Fri, 11 Apr 2008 21:23:38 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: galak@kernel.crashing.org, khali@linux-fr.org, scottwood@freescale.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, jonsmirl@gmail.com, laurentp@cse-semaphore.com
Subject: Re: [PATCH3/7] i2c: OF helpers for the i2c API
References: <47FF710D.2040208@scram.de> <20080411.104306.93639801.davem@davemloft.net>
In-Reply-To: <20080411.104306.93639801.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller schrieb:

> I wouldn't mind trying to use this infrastructure on
> sparc64, and I don't see any powerpc specific interfaces
> being invoked, so if you could remove the PPC_OF
> requirement I'd appreciate it.

I've resenf the patch without the dependency on PPC_OF.

Thanks for the comment.
Jochen
