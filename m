Return-Path: <linux-kernel-owner+w=401wt.eu-S2993097AbXDTNQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993097AbXDTNQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993248AbXDTNQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:16:19 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:48507 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993097AbXDTNQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:16:19 -0400
Message-ID: <4628BD0E.3040206@free.fr>
Date: Fri, 20 Apr 2007 15:15:58 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, tglx@timesys.com, linux.kernel@free.fr
Subject: PREEMPT_RT: 2.6.20-rt8 patch tweaked for 2.6.20.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've tweaked patch-2.6.20-rt8(*) so that it applies to 2.6.20.7
(*) http://rt.wiki.kernel.org/index.php/Main_Page

The original patch can be found here:
http://people.redhat.com/mingo/realtime-preempt/older/patch-2.6.20-rt8
http://linux.kernel.free.fr/patch-2.6.20-rt8

diff to the original patch to show what was tweaked:
http://linux.kernel.free.fr/patch-2.6.20-rt8.diff

New patch that applies cleanly to 2.6.20.7:
http://linux.kernel.free.fr/patch-2.6.20.7-rt8

As always, if someone spots something I've done wrong,
I'd be happy to fix it in a hurry :-)

Ingo, Thomas, are there any fixes that were included in the 2.6.21-rt 
branch only that need to be back-ported to the 2.6.20-rt branch?

Regards.

