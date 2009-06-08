Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZFHBi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZFHBi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZFHBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:38:19 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:17856 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZFHBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:38:18 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jun 2009 21:38:18 EDT
Message-Id: <6.2.5.6.2.20090606235223.05a10068@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Sun, 07 Jun 2009 21:25:06 -0400
To: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>
From: starlight@binnacle.cx
Subject: Re: [PATCH 0/2] Fixes for hugetlbfs-related problems on
  shared memory
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Eric B Munson <ebmunson@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       Andy Whitcroft <apw@canonical.com>, wli@movementarian.org
In-Reply-To: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

Tried out the two new patches on 2.6.26.4 and everything is 
working now.  The application that uncovered the issue works 
perfectly and hugepages function sanely.

Thank you for the fix.

Regards

