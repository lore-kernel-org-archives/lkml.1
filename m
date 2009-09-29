Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZI2MZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZI2MZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZI2MZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:25:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44689 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZI2MZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:25:32 -0400
Message-Id: <20090929122514.693636761@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Sep 2009 14:25:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/2] nohz tweaking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
the two remainting patches of the nohz performance work I've been
doing. Both have been sent to the mailing lists before. Ingo had
a comment about patch #1, but no one but me seems to be interested
in patch #2. Neverless I would like to get both patches upstream.
I can create a branch for them on git390 but I feel that they should
go the path all the other nohz/time/clocksource patches went.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
