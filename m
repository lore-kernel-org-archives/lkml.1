Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbZAOIAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbZAOIAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZAOIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:00:06 -0500
Received: from mx.hosting-seguridad.com ([88.198.93.158]:35648 "EHLO
	mx.hosting-seguridad.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZAOIAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:00:05 -0500
X-Spam-Score: -2.343
Message-ID: <496EED00.3020102@rs-labs.com>
Date: Thu, 15 Jan 2009 09:00:00 +0100
From: Roman Medina-Heigl Hernandez <roman@rs-labs.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Oops with Gigabyte motherboard "GA-X48-DQ6" and r8168 Realtek
 driver
References: <49671B77.7080705@rs-labs.com> <200901101255.07611.alistair@devzero.co.uk> <4968ED53.8060404@rs-labs.com> <200901102035.19733.alistair@devzero.co.uk> <496A3527.2090702@rs-labs.com>
In-Reply-To: <496A3527.2090702@rs-labs.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Medina-Heigl Hernandez escribió:
> I've built two custom .deb packages for kernels:
> - 2.6.28
> - 2.6.27.10
> 
 > I'll probably go for 2.6.27.10. If you think I'm not right, please, correct
> me :-)
> 
> I'll try to install one of the new kernels tomorrow evening...

Hello,

I installed 2.6.27.10 on monday. No problems arised since then, it seems
stable. I'm using r8169 built-in kernel driver instead of r8168 vendor
module. To be honest I'm not sure whether the problem was due to this r8168
driver, or it's simply that 2.6.18 is too much old for a modern PC (with
Quad core).

Thank you to all for your contribution, specially to Alistair.

Cheers,
-Roman

