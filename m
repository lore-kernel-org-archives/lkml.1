Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZCFPEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZCFPEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZCFPDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:03:52 -0500
Received: from fifo99.com ([67.223.236.141]:52479 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbZCFPDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:03:51 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903060955230.3461-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903060955230.3461-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 07:03:48 -0800
Message-Id: <1236351828.5937.130.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 09:57 -0500, Alan Stern wrote:

> It is _not_ diehard, at least not according to Linus.  He has posted a 
> couple of messages expressing his opinion that overall readability is 
> more important than sticking rigidly to 80 columns.

My experience has been that anyone sending over 80 columns is sure to
get slammed, just like with this document patch. So when I say it's die
hard that's what I mean. Plus we have the checkpatch clean phenomenon.
So Linus may not care but everyone else on this list does seem to care..

Daniel

