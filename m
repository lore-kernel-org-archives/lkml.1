Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYDWLZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYDWLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYDWLZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:25:51 -0400
Received: from mail0.scram.de ([78.47.204.202]:59610 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYDWLZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:25:50 -0400
X-Spam-Score: -4.2
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <480F1CB5.6050307@scram.de>
Date: Wed, 23 Apr 2008 13:25:41 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [2.6 patch] drivers/of/of_i2c.c: add MODULE_LICENSE
References: <20080423095134.GZ28933@cs181133002.pp.htv.fi>
In-Reply-To: <20080423095134.GZ28933@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:

> After commit 585468e5d5962660867c269e26f0a4b89a599473
> ([POWERPC] i2c: Fix build breakage introduced by OF helpers)
> drivers/of/of_i2c.c needs a MODULE_LICENSE.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Jochen Friedrich <jochen@scram.de>

Thanks,
Jochen
