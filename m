Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZG0Vk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZG0Vk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZG0Vk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:40:27 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:51497 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZG0Vk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:40:27 -0400
Date: Mon, 27 Jul 2009 22:40:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: David Vrabel <david.vrabel@csr.com>
Cc: Philip Langdale <philipl@overt.org>,
       Andrew Morton <akpm@linux-foundation.org>, ohad@bencohen.org,
       ian@mnementh.co.uk, pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es
Subject: Re: New MMC maintainer needed
Message-ID: <20090727214001.GK12665@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090722151744.fffd7bf5.akpm@linux-foundation.org> <4A67A9E8.5080002@mnementh.co.uk> <20090723055447.GA12211@console-pimps.org> <20090722232259.d0ff3495.akpm@linux-foundation.org> <20090724152944.51402e87.akpm@linux-foundation.org> <20090726230630.7598fbe4@fido2.homeip.net> <4A6D990B.9000005@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6D990B.9000005@csr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 01:09:47PM +0100, David Vrabel wrote:
> Philip Langdale wrote:
> > 
> > Both the (Simplified) SD and SDIO specifications do not formally
> > define the 'low voltage' range in the way the MMC spec does. ie: You
> > won't find anything in the SD specs that even tell you what the range
> > is - it just says that it exists.
> 
> Standard SD/SDIO cards only support 2.7-3.6V.
> 
> 1.8V operation is added in SD physical spec 3.00 and is part of any of
> the UHS-1 modes (SDR12-SDR104 and DDR50).  It has a different timings
> and requires a different (3.00 compliant) host controller.

Is the 3.00 spec publicly available?
