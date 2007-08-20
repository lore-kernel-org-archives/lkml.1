Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXHTXUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXHTXUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXHTXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:20:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57651 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXHTXUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:20:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46CA21B9.9050008@s5r6.in-berlin.de>
Date: Tue, 21 Aug 2007 01:20:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-hrt2: tasklets replaced by workqueues?
References: <46C94EB1.1070403@s5r6.in-berlin.de>
In-Reply-To: <46C94EB1.1070403@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I've got a driver bug filed against 2.6.23-rc3-hrt2 with an oops beneath
> run_workqueue.  It looks a lot like another bug in mainline with a panic
> beneath run_timer_softirq.  Does -hrt replace tasklets by workqueues?
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8906
> http://bugzilla.kernel.org/show_bug.cgi?id=8646

Never mind.  These are different bugs.
-- 
Stefan Richter
-=====-=-=== =--- =-=-=
http://arcgraph.de/sr/
