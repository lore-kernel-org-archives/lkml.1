Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbZFWNre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbZFWNre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbZFWNr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:47:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48046 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZFWNr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:47:26 -0400
Date: Tue, 23 Jun 2009 22:46:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, niv@us.ibm.com,
       dvhltc@us.ibm.com, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v5 RCU: the bloatwatch edition
Message-ID: <20090623134627.GB26674@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	niv@us.ibm.com, dvhltc@us.ibm.com, kernel@wantstofly.org,
	matthew@wil.cx
References: <20090623042442.GA15630@linux.vnet.ibm.com> <28711.1245748358@redhat.com> <20090623093208.GD23698@elte.hu> <20090623125832.GA6872@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623125832.GA6872@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 05:58:32AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 23, 2009 at 11:32:08AM +0200, Ingo Molnar wrote:
> > Paul, i guess this is .32 material anyway, right?
> 
> I am personally OK with it being .32, as long as David Howells,
> Lennert Buytenhek, and Paul Mundt are OK with that schedule.
> 
It's hard to see how this is going to cause any regressions, so I don't
see any problem with this going in to 2.6.31. OTOH, it's not too
pressing, so 2.6.32 is ok for me too.
