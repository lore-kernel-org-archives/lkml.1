Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbXEQASp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbXEQASp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXEQASh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:18:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55886 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbXEQASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:18:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464B9EF7.1090808@s5r6.in-berlin.de>
Date: Thu, 17 May 2007 02:16:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk> <464B141E.3020400@s5r6.in-berlin.de> <464B9427.1010204@freescale.com>
In-Reply-To: <464B9427.1010204@freescale.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> Stefan Richter wrote:
>> "A... select B" is just a flavor of "A... depends on B",
...
> I think you mean "A... select B" is just a flavor of "B... depends on
> A".

No, A requires B's symbols.
-- 
Stefan Richter
-=====-=-=== -=-= =---=
http://arcgraph.de/sr/
