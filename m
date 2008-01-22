Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYAVXuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYAVXuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYAVXuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:50:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:42127 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYAVXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:50:03 -0500
Date: Wed, 23 Jan 2008 00:50:02 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Massive IDE problems. Who leaves data here?
In-Reply-To: <fn5l9c$l6m$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0801230047180.9183@fbirervta.pbzchgretzou.qr>
References: <fn5ivo$ck2$1@ger.gmane.org> <47965138.8060603@garzik.org> 
 <fn5jsn$ful$1@ger.gmane.org> <2c0942db0801221246u678d2a20xef9cf93ee28eaf51@mail.gmail.com>
 <fn5l9c$l6m$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 22 2008 22:04, Manuel Reimer wrote:
>
> ... that may be possible...
>
> I have all PCI slots filled with cards, two big IDE hard drives and one DVD RAM
> writer. I already disconnected the DVD drive, as this was nearly unusable with
> all those IDE errors. The power supply is (AFAIR) a 200 watt one.

Ugh, 250 W was a safe^[0] minimum even back in '98 when harddisks were
like 4.3GB and a dual-speed CD-RW drive was like $400 and up. You
seriously need to replace that.

[0] e.g. suited for 2 CD drives and 2 harddisks, 2 PCI and 1 AGP
