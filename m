Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXFQHPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXFQHPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 03:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXFQHPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 03:15:04 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:61639 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbXFQHPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 03:15:03 -0400
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 00:15:00 -0700
Message-Id: <1182064500.2798.6.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 20:33 -0700, Linus Torvalds wrote:
> In a stunning turn of events, I've actually been able to make another -rc 
> release despite all the discussion (*cough*flaming*cough*) about other 
> issues, and we now have a brand-spanking-new Linux 2.6.22-rc5 release 
> out there!
> 

signalfd still has the broken behavior w.r.t. signal delivery to
threads.

Is this going to get fixed before 2.6.22 proper is released, or should
it just be disabled entirely so no userspace apps grow to depend on
current wrong behavior?

-- 
Nicholas Miell <nmiell@comcast.net>

