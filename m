Return-Path: <linux-kernel-owner+w=401wt.eu-S1945993AbXEAVyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945993AbXEAVyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXEAVyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:54:47 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:43714 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1945993AbXEAVyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:54:46 -0400
Message-ID: <4637B751.1080907@cfl.rr.com>
Date: Tue, 01 May 2007 17:55:29 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Execute in place
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2007 21:54:58.0932 (UTC) FILETIME=[5CAF9B40:01C78C3B]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15150.001
X-TM-AS-Result: No--3.653400-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to remember seeing some patches go by at some point that allowed 
one of the rom type embeded system filesystems to directly execute 
binaries out of the original rom memory rather than copying them to ram 
first, then executing from there.  I was wondering if rootfs or tmpfs 
support such execute in place today, or if binaries executed from there 
have their code segments duplicated in ram?
