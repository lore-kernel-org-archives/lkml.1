Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYDXKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYDXKfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYDXKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:35:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38221 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYDXKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:35:30 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 06:35:30 EDT
Cc: linux-arm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <392801C2-25A6-4AF1-9DFD-0C8FF0C8C6B6@caiaq.org>
From: Daniel Mack <daniel@caiaq.org>
To: Michael Abbott <michael@araneidae.co.uk>
In-Reply-To: <20080424095917.Q51356@saturn.araneidae.co.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] Colibri: Fix support for DM9000 ethernet device.
Date: Thu, 24 Apr 2008 12:24:10 +0200
References: <20080424095917.Q51356@saturn.araneidae.co.uk>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.04.2008, at 12:13, Michael Abbott wrote:

> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>
> Colibri: Fix support for DM9000 ethernet device.
>
> Two changes are necessary to enable proper operation of the DM9000  
> device
> with the Colibri PXA 270 board: firstly, the IRQ type needs to be
> configured for rising edge interrupts, and secondly this  
> configuration needs
> to be communicated through to the DM9000.
>
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>

Acked-by: Daniel Mack <daniel@caiaq.de>

