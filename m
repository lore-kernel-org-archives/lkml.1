Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXLJPJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXLJPJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXLJPI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:08:59 -0500
Received: from gherkin.frus.com ([192.158.254.49]:51057 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLJPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:08:58 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <20071209210729.A20635@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Dec 9, 2007 09:07:29 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Mon, 10 Dec 2007 09:08:53 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       linux-scsi@vger.kernel.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071210150853.DEE18DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On Sat, Dec 08, 2007 at 10:19:39PM -0600, Bob Tracy wrote:
> > I *do* have CONFIG_MAGIC_SYSRQ set.  Anyone care to bet whether my
> > machine starts working again if I disable it?  Sheesh...
> 
> Incredible...
> 
> Toggling CONFIG_MAGIC_SYSRQ works for me too, so I'm finally able
> to reproduce the problem (which is the main positive result so far ;-)
> 
> There are lots of possible reasons why this happens, but at the
> moment I honestly have no idea.
> For now I have reassigned the bug #9457 to myself and will gradually hack
> into udev...

Thanks...  Let me know if there's anything useful I can do to help.

--Bob T.
