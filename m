Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340Ab0A0LJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0A0LJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253Ab0A0LI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:08:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:49952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0A0LI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:08:58 -0500
Subject: Re: linux-next: add utrace tree
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, avi@redhat.com
In-Reply-To: <20100127110555.GB1842@in.ibm.com>
References: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop>
	 <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
	 <1264589716.4283.2006.camel@laptop>  <20100127110555.GB1842@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 12:08:31 +0100
Message-ID: <1264590511.4283.2009.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 16:35 +0530, Ananth N Mavinakayanahalli wrote:
> Probing RIP-relative instructions work just fine; there are fixups that
> take care of it. 

Ah my bad then, it was my understanding you simply bailed on those.

Just for my information, how large are the replacement sequences?

