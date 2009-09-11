Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZIKEWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZIKEWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZIKEWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:22:20 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:51670 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZIKEWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:22:19 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: LKML <linux-kernel@vger.kernel.org>,
       Hisham Muhammad <loderunner@users.sourceforge.net>
Subject: slight regression in 2.6.31, htop doesn't see cpu usage
Date: Fri, 11 Sep 2009 00:21:48 -0400
User-Agent: KMail/1.12.0 (Linux/2.6.31; KDE/4.3.0; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200909110021.49069.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Particularly to the htop author,  Hisham Muhammad

I enabled the latency testing so I could run latencytop & maybe learn a bit 
more, and I just noticed that while gkrellm is displaying the cpu usage 
graphics on an individual core basis (4 core phenom), but htop is reporting 
everything is at 0.0 cpu usage.  Is this possibly an artifact of enabling the 
latency testing things, or have I found a buglet?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The last thing one knows in constructing a work is what to put first.
-- Blaise Pascal
