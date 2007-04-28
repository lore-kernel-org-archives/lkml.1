Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXD1TCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXD1TCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXD1TCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:02:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbXD1TCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:02:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] use elfnote.h to generate vsyscall notes
In-Reply-To: Jeremy Fitzhardinge's message of  Saturday, 28 April 2007 00:29:50 -0700 <4632F7EE.6080101@goop.org>
X-Zippy-Says: YOW!  I can see 1987!!  PRESIDENT FORD is doing the REMAKE of
   "PAGAN LOVE SONG"...he's playing ESTHER WILLIAMS!!
Message-Id: <20070428190137.8E56C1801A4@magilla.sf.frob.com>
Date: Sat, 28 Apr 2007 12:01:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You're right.  I was thinking of the output section name in the DSO.
