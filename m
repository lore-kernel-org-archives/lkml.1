Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbXGFUvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbXGFUvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXGFUvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:51:00 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:63475 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbXGFUu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:50:59 -0400
Date: Fri, 6 Jul 2007 22:50:45 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Question about cpufreq governors
Message-ID: <20070706205045.GA2778@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I have an AMD Athlon64, and according to "powernow-k8", it has to
fid's, for 1000MHz and 1800MHz. I don't know if this is correct or if I
should enable ACPI to have more fid's, but my question is not about
this.

    What I want to know is if I can choose "ondemand" governor instead
of the recommended for AMD64, namely the "conservative" governor, since
I will be switching between those two frequencies. I haven't found any
information about my CPU regarding latency when switching between
frequencies, so I don't know if I will be gaining anything using the
"conservative" governor.

    Which governor is better suited for a CPU with only two fid's,
"ondemand" or "conservative"?

    Thanks a lot in advance :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
