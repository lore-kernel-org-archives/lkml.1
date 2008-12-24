Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbYLXS5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbYLXS5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 13:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLXS5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 13:57:01 -0500
Received: from adsl100-93.ath.forthnet.gr ([79.103.127.93]:41692 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYLXS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 13:57:00 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Dec 2008 13:57:00 EST
Message-ID: <49528352.9000906@asyr.hopto.org>
Date: Wed, 24 Dec 2008 20:45:38 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081222)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Sil 3132 SATA II express card
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have compiled in kernel (2.6.27) support for Sil 3132:
CONFIG_SATA_SIL24=y

When I insert the card in the laptop's slot, dmesg shows nothing new.
Is this normal?

