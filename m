Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXDWG7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXDWG7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDWG7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:59:47 -0400
Received: from 65-117-135-114.dia.static.qwest.net ([65.117.135.114]:52819
	"EHLO postfix.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbXDWG7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:59:46 -0400
Subject: Re: PREEMPT_RT: 2.6.20-rt8 patch tweaked for 2.6.20.7
From: Thomas Gleixner <tglx@timesys.com>
Reply-To: tglx@timesys.com
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <4628BD0E.3040206@free.fr>
References: <4628BD0E.3040206@free.fr>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 09:01:17 +0200
Message-Id: <1177311677.30986.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Fri, 2007-04-20 at 15:15 +0200, John Sigler wrote:
> I've tweaked patch-2.6.20-rt8(*) so that it applies to 2.6.20.7
> (*) http://rt.wiki.kernel.org/index.php/Main_Page
> 
> The original patch can be found here:
> http://people.redhat.com/mingo/realtime-preempt/older/patch-2.6.20-rt8
> http://linux.kernel.free.fr/patch-2.6.20-rt8
> 
> diff to the original patch to show what was tweaked:
> http://linux.kernel.free.fr/patch-2.6.20-rt8.diff
> 
> New patch that applies cleanly to 2.6.20.7:
> http://linux.kernel.free.fr/patch-2.6.20.7-rt8
> 
> As always, if someone spots something I've done wrong,
> I'd be happy to fix it in a hurry :-)
> 
> Ingo, Thomas, are there any fixes that were included in the 2.6.21-rt 
> branch only that need to be back-ported to the 2.6.20-rt branch?

I've been busy with mainline merge of highres timers lately, so I have
no good overview of the -rt state at the moment, but I will check on
this later that week.

Can you create an entry in the rt-wiki, so people can find your
patches ?

	tglx


