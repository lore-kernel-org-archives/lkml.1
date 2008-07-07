Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYGGV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYGGV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYGGV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:27:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:52207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756277AbYGGV1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:27:20 -0400
X-Authenticated: #10554321
X-Provags-ID: V01U2FsdGVkX1/dnVAqDYjdeXgHoKXp8b7S4MY0ZGPezvf+jUmNOv
	VlPl7+WwlTLjKS
From: Stefan Bauer <stefan-a-bauer@gmx.net>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 23:27:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072327.17714.stefan-a-bauer@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 7. Juli 2008 schrieb Stefan Bauer:

> dmesg 2.6.26-rc9
> ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
> phy0: Selected rate control algorithm 'pid'
> phy0: Failed to initialize wep
> phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> rt2500pci: probe of 0000:00:0c.0 failed with error -12
>
> .config 2.6.26-rc9
> <http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config>
>
> Next I'm going to test 2.6.24 and 2.6.25 to check whether it's an
> regression or not.

Same problem with 2.6.24.7, I'll skip 2.6.25.


Regards, Stefan
