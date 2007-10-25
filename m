Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXJYKlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXJYKlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbXJYKlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:41:09 -0400
Received: from smile.2scale.net ([212.12.33.142]:4899 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXJYKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:41:08 -0400
Subject: Linux 2.6.22.7 Machine Check Exception
From: Michael Stiller <ms@2scale.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: 2scale GmbH
Date: Thu, 25 Oct 2007 12:40:58 +0200
Message-Id: <1193308858.3808.2.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i encountered the following machine check exceptions (and hangs) with
2.6.22.7 on an Dual Core-2 Xeon System. It occurs if i try to use the
PCI-X Intel Gigabit Ethernet card after some minutes:

CPU 3: Machine Check Exception 0000000000000005
Bank 0: b200004010000400
Bank 5: b200121020000400

or

CPU 1: Machine Check Exception 0000000000000005
Bank 0: b200004010000400
Bank 5: b200121020000400

What is the cause? How can this be debugged?

Cheers,

-Michael

