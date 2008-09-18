Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYIRPD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYIRPD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYIRPDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:03:22 -0400
Received: from mx1.suse.de ([195.135.220.2]:42968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYIRPDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:03:21 -0400
From: Andreas Schwab <schwab@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] [UIO] Add alignment warnings for uio-mem
References: <20080918144615.GD4226@pengutronix.de>
X-Yow: I put aside my copy of ``BOWLING WORLD'' and think
 about GUN CONTROL legislation..
Date: Thu, 18 Sep 2008 17:03:19 +0200
In-Reply-To: <20080918144615.GD4226@pengutronix.de> (Wolfram Sang's message of
	"Thu, 18 Sep 2008 16:46:15 +0200")
Message-ID: <jeljxpfqdk.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <w.sang@pengutronix.de> writes:

> +			dev_warn(idev->dev, "mem[%d] not page aligned!"
> +				"Fixing values.\n", mem - info->mem);

Minor nit: please add a space to the message.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
