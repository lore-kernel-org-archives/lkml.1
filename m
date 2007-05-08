Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbXEHBlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbXEHBlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934434AbXEHBk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:40:58 -0400
Received: from khc.piap.pl ([195.187.100.11]:55527 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429AbXEHBk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:40:57 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Russell King <rmk@arm.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 0/3] Intel IXP4xx network drivers
References: <m3abwhcy74.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 03:40:56 +0200
In-Reply-To: <m3abwhcy74.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Mon, 07 May 2007 01:46:39 +0200")
Message-ID: <m3vef43xef.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, the status of my patches is as follows:
[PATCH] Use menuconfig objects II - netdev/wan
        the "menuconfig" WAN patch by Jan Engelhardt

[PATCH 1a/3] WAN Kconfig: change "depends on HDLC" to "select"
        the Kconfig changes for WAN (HDLC) drivers

[PATCH 2a/3] Intel IXP4xx network drivers
	IXP4xx "fuses" (installed on-chip CPU components) patch

[PATCH] Intel IXP4xx network drivers v.3 - QMGR
	IXP4xx hardware Queue Manager driver

[PATCH] Intel IXP4xx network drivers v.2 - NPE
	IXP4xx Network Processor Engine driver, needs "fuses" patch

[PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
	You guessed it, needs all of the above.


The:
[PATCH] Intel IXP4xx network drivers v.2 - QMGR
was faulty, thus v.3.

Fire again :-)
-- 
Krzysztof Halasa
