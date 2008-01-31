Return-Path: <linux-kernel-owner+w=401wt.eu-S1764760AbYAaIch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764760AbYAaIch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYAaIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:32:28 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:55034 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbYAaIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:32:27 -0500
Subject: Re: [PATCH 6/6] s390: Use generic percpu linux-2.6.git
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080130215339.GC28242@elte.hu>
References: <20080130180940.022172000@sgi.com>
	 <20080130180940.921597000@sgi.com>  <20080130215339.GC28242@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 31 Jan 2008 09:32:26 +0100
Message-Id: <1201768346.18221.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 22:53 +0100, Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
> > Change s390 percpu.h to use asm-generic/percpu.h
> 
> do the s390 maintainer agree with this change (Acks please), and has it 
> been tested on s390?

Now I'm confused. The patch has been acked a few weeks ago and the last
5+ version of the patch had the acked line. The lastest version dropped
it for a reason I don't know. And more, the patch is already upstream
with the (correct) acked line, see git commit
f034347470e486835ccdcd7a5bb2ceb417be11c4.
So, what is the problem ?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


