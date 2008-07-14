Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYGNVfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYGNVfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbYGNVfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:35:46 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:44940 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYGNVfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:35:46 -0400
Date: Tue, 15 Jul 2008 01:35:29 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: hifn_795x in a MacMini?
Message-ID: <20080714213529.GA447@2ka.mipt.ru>
References: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian.

On Mon, Jul 14, 2008 at 09:18:09PM +0200, Christian Kujau (lists@nerdbynature.de) wrote:
> Somehow this message sounds to me, as if this MacMini does have such a 
> chip. This would be surprising, as I thought the chip is a highly 
> specialized one, and expensive too. Also 
> there's no ../devices/ symlink in /sys/bus/pci/drivers/hifn795x. Still, 
> why would the driver load into the kernel when there's no such chip?

If you have appropriate hardware, then following string will be printed
in dmesg:

AES 128 ECB test has been successfully passed

-- 
	Evgeniy Polyakov
