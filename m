Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYFXWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYFXWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYFXWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 18:31:47 -0400
Received: from mxsec.euro-web.fr ([81.93.243.199]:52844 "EHLO
	mxsec.euro-web.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFXWb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 18:31:27 -0400
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: linux-kernel@vger.kernel.org
Subject: Re: weird bug on r8169 with usb
Date: Wed, 25 Jun 2008 00:31:24 +0200
User-Agent: KMail/1.9.7
References: <200806250018.37617.david.ml@euro-web.fr>
In-Reply-To: <200806250018.37617.david.ml@euro-web.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806250031.24804.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 25 June 2008 00:18:37 David CHANIAL, vous avez écrit :
> # dmesg | grep eth0 # without the bug

excuse my error (copy/paste error),
without the bug, the output is :

# dmesg | grep eth0 # without the bug
eth0: RTL8168c/8111c at 0xf8828000, 00:1e:8c:c4:66:7d, XID 3c2000c0 IRQ 18
r8169: eth0: link up
r8169: eth0: link up
eth0: no IPv6 routers present

Note that i can boot without the usb devices
eth0 is usable, i plug usb devices and eth0 continue to be fully usable.
the bug occur only when i boot with the usb devices.

Best regards,
-- 
David CHANIAL
