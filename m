Return-Path: <linux-kernel-owner+w=401wt.eu-S965727AbXJPUeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727AbXJPUeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964780AbXJPUdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:33:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:56884 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964867AbXJPUdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:33:45 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 16 Oct 2007 22:33:41 +0200
In-Reply-To: <m3d4vebylw.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Tue, 16 Oct 2007 22:20:27 +0200")
Message-ID: <m38x62bxzu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

[VIA VT6306/6307]

> I haven't yet checked if it changes OHCI version - I of course
> could program the EEPROM externally but I think I'd better find
> how to do that from PCI side.

Added Cc:lkml, perhaps someone at VIA could find that strictly
confidential and destroy-before-reading document and spare me
the effort? :-)

All I need to know is:
a) meaning of the config EEPROM data for VIA firewire chips
b) how to read/write the EEPROM from PCI side (i.e., probably
EECS, EEDO, EEDI/SDA and EECK/SCL bit locations or however
it's done).
-- 
Krzysztof Halasa
