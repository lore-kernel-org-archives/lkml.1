Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbZE2PDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbZE2PDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbZE2PCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:02:54 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:12130 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbZE2PCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:02:53 -0400
X-SourceIP: 213.93.53.227
Subject: Re: comments on Performance Counters for Linux (PCL)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470905290343q2ec107f1o81a7b80232e42080@mail.gmail.com>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
	 <7c86c4470905290343q2ec107f1o81a7b80232e42080@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 17:02:53 +0200
Message-Id: <1243609373.23657.264.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 12:43 +0200, stephane eranian wrote:
> > I can't seem to locate the IBS stuff in the documentation currently, and
> > I must admit I've not yet looked into it, others might have.
> >
> AMD BIOS and Kernel Developer's Guide (BKDG) for Family 10h, section 3.13.
> You have the register descriptions.

Gah, I only downloaded BKDG for Family 11h under the assumption it would
include everything 10h had and then some,.. how ignorant of me :(

