Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbZAPIdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbZAPIdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764621AbZAPIca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:32:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:40411 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764505AbZAPIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:32:30 -0500
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX18QrsBg9owQwvbNy/M1LFWqIfqiTj9zEVk8em3aqW
	Z9X3qEYObMu6pG
Message-ID: <4970461B.4080706@gmx.de>
Date: Fri, 16 Jan 2009 09:32:27 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hex digits in ACPI HIDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everyone!

I believe ACPI _HIDs (including PNP IDs) should be all uppercase, 
including the hex digits A through F. I would like to prepare a patch 
fixing all occurences of lowercase hex digits in ACPI HIDs.

My question: Can I send a single patch fixing about 90 occurences in 
about 25 files or should I prepare a series of patches, one for each 
file/driver?

Thanks,
- Philipp Kohlbecher
