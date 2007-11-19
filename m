Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbXKSKf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbXKSKf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 05:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXKSKfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 05:35:18 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49854 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbXKSKfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:35:16 -0500
Date: Mon, 19 Nov 2007 13:34:28 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Patrick McHardy <kaber@trash.net>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, mb@bu3sch.de,
       linux-kernel@vger.kernel.org
Subject: Re: [HIFN 00/03]: RNG support v2
Message-ID: <20071119103428.GB2048@2ka.mipt.ru>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick.

On Sun, Nov 18, 2007 at 10:32:52PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> These patches add support for using the HIFN rng.

> Patrick McHardy (3):
>       [HWRNG]: move status polling loop to data_present callbacks
>       [HIFN]: Improve PLL initialization
>       [HIFN]: Add support for using the random number generator

Thanks a lot for your patches.
Ack for all three.

-- 
	Evgeniy Polyakov
