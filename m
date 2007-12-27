Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXL1WJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXL1WJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 17:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXL1WJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 17:09:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbXL1WJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 17:09:42 -0500
Message-ID: <47742268.8040302@cinatas.ath.cx>
Date: Thu, 27 Dec 2007 23:08:40 +0100
From: Sascha Warner <prx@cinatas.ath.cx>
User-Agent: Thunderbird 2.0.0.9 (X11/20071207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ha2I2aRpMgMW408ZkxJTpYlqSlh5DKeKN3cr
 8UBh6twjOskjPquZ/I3H61wcElD11OXP0jbric36GO5NoWHIoj
 4YgHSFEPIkkNFoy1ICiiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
pdflush often using 100% CPU for a long time. There seem to be some rare
pauses from its 100% usage, however.

On ~23 minutes uptime i have ~19 minutes pdflush runtime.

This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo ~x64_64

Let me know if you need more info.


Prost,
Sascha Warner


