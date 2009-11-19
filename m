Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZKSSYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZKSSYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZKSSY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:24:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZKSSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:24:29 -0500
Message-ID: <4B058CCD.8050605@redhat.com>
Date: Thu, 19 Nov 2009 18:22:05 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Richard Guenther <richard.guenther@gmail.com>
CC: rostedt@goodmis.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> 	 <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> 	 <20091119072040.GA23579@elte.hu> 	 <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 	 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> 	 <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> 	 <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain> 	 <1258653562.22249.682.camel@gandalf.stny.rr.com> <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
In-Reply-To: <84fc9c000911191003t244eb864o3d5b355ab5485f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Guenther wrote:

> And
> you didn't provide us with a testcase either ... so please open
> a bugzilla and attach preprocessed source of a file that
> shows the problem, note the function it happens in and provide
> the command-line options you used for building.

I've got all that off-list.  I found the cause, and replied in another
email.  It's not a bug.

Andrew.
