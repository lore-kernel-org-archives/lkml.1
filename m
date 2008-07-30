Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbYG3NWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbYG3NWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYG3NWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:22:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYG3NWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:22:36 -0400
Date: Wed, 30 Jul 2008 06:22:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Message-ID: <20080730062220.08b2779a@infradead.org>
In-Reply-To: <16453842.205951217418535898.komurojun-mbn@nifty.com>
References: <20080729065859.2bcc65ed@infradead.org>
	<20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	<20080729215315.5a505fe7.komurojun-mbn@nifty.com>
	<16453842.205951217418535898.komurojun-mbn@nifty.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:48:55 +0900 (JST)
Komuro <komurojun-mbn@nifty.com> wrote:

> 
> >
> >"I have a hardware failure so I'll comment out the message that says
> >so, and then I won't have a failure". Yeah that'll work well.
> 
> 
> O.K. The madwifi should be fixed.
> Thanks,

madwifi has many bigger issues; it's been number 1 in the kerneloops
top 10 for months and months now.

Feel free to fix it.. I can't.. it's a proprietary/binary driver.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
