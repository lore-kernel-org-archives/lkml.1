Return-Path: <linux-kernel-owner+w=401wt.eu-S1161705AbXDXH5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161705AbXDXH5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161706AbXDXH5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:57:39 -0400
Received: from [70.254.190.220] ([70.254.190.220]:35866 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161705AbXDXH5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:57:38 -0400
Date: Tue, 24 Apr 2007 07:57:37 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
Subject: cpufreq default governor
Message-ID: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question: is there some reason that kconfig does not allow for default 
governors of conservative/ondemand/powersave?
I'm not aware of any reason why one of those governors could not be used 
as default.

William Heimbigner
icxcnika@mar.tar.cc
