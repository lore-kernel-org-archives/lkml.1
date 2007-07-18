Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXGRW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXGRW1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXGRW1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:27:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56190 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXGRW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:27:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469E93AF.3080202@s5r6.in-berlin.de>
Date: Thu, 19 Jul 2007 00:26:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Jay Fenlason <fenlason@redhat.com>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] FireWire updates
References: <tkrat.f5ba2b840fcda9e5@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f5ba2b840fcda9e5@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>       firewire: fw-ohci: flush MMIO write before msleep
>       firewire: fw-ohci: fix "scheduling while atomic"
>       firewire: remove bogus check in fw_core_handle_request
>       firewire: fix memory leak of fw_request instances
>       firewire: fw-sbp2: convert to new SCSI data buffer accessors

PS:  Kudos to Jay Fenlason for doing the difficult and time-consuming
parts of it, the memleak debugging.
-- 
Stefan Richter
-=====-=-=== -=== =--==
http://arcgraph.de/sr/
