Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZEXXfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZEXXfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 19:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZEXXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 19:35:06 -0400
Received: from mail.lang.hm ([64.81.33.126]:35853 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZEXXfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 19:35:05 -0400
Date: Sun, 24 May 2009 16:34:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Harald Dunkel <harald.dunkel@t-online.de>
Subject: [Bug #13175] sata_nv incompatible with async scsi scan
In-Reply-To: <WCcYF-TAbJC.A.tSD.gQcGKB@chimera>
Message-ID: <alpine.DEB.1.10.0905241632150.18053@asgard>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <WCcYF-TAbJC.A.tSD.gQcGKB@chimera>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if these two bugs are related? when I can get into the office I 
will try disabling the async scsi scan and re-test 12703


Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13175
Subject         : sata_nv incompatible with async scsi scan
Submitter       : Benny Halevy <bhalevy@panasas.com>
Date            : 2009-04-21 7:03 (34 days old)
References      : http://marc.info/?l=linux-kernel&m=124029746431777&w=4

[Bug 12703] Intel X25-E 32GB+MCP55_nvidia_sata+2.6.28=it not work together

David Lang
