Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXLEDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXLEDy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXLEDyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:54:20 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:61149 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLEDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:54:19 -0500
Date: Tue, 4 Dec 2007 22:53:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
In-Reply-To: <20071204194719.e048ebc1.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.58.0712042252510.19640@gandalf.stny.rr.com>
References: <1196801858.1645.37.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
 <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
 <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
 <20071204194719.e048ebc1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Dec 2007, Randy Dunlap wrote:
>
> Steve/David,
>
> where can I find the test case, please?

David attached it to the RH Bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=408321

-- Steve

