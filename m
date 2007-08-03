Return-Path: <linux-kernel-owner+w=401wt.eu-S1763127AbXHCOcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763127AbXHCOcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbXHCOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:31:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762207AbXHCOby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:31:54 -0400
Date: Fri, 3 Aug 2007 10:31:50 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Bromley <sbromley@pangeosubsea.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EIP: [dnotify_flush+104/160] dnotify_flush+0x68/0xa0 SS:ESP
	0068:ecf85f80
Message-ID: <20070803143150.GC11942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Bromley <sbromley@pangeosubsea.com>,
	linux-kernel@vger.kernel.org
References: <46B32E15.2060308@pangeosubsea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B32E15.2060308@pangeosubsea.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 11:01:01AM -0230, Sam Bromley wrote:

 > ( Linux version 2.6.20-15-generic (root@palmer) (gcc version 4.1.2 
 > (Ubuntu 4.1.2-0ubuntu4)) #2 SMP Sun Apr 15 07:36:31

ancient kernel (and a vendor patched one at that)

 > snd_page_alloc pcspkr gameport nvidia(P) parport serio_raw soundcore 

and tainted with binary only drivers.

No-one here can help you.

	Dave

-- 
http://www.codemonkey.org.uk
