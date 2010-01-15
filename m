Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0AOQWP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307Ab0AOQWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:22:14 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:49606 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab0AOQWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:22:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAGMiUEuuWOiG/2dsb2JhbACBRNgEhDEEgx8
Date: Fri, 15 Jan 2010 11:17:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: 1Q2010 update for RCU
	documentation
Message-ID: <20100115161705.GA30678@Krystal>
References: <20100115020131.GA20934@Krystal> <20100115023029.GG9077@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100115023029.GG9077@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:14:43 up 30 days, 33 min,  4 users,  load average: 0.19, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Jan 14, 2010 at 09:01:31PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > Add expedited functions.  Review documentation and update obsolete
> > > verbiage.  Also fix the advice for the RCU CPU-stall kernel configuration
> > > parameter, and document RCU CPU-stall warnings.
> > > ---
> > [...]
> > > +
> > > +@phdthesis{MathieuDesnoyersPhD
> > > +, title  = "Low-impact Operating System Tracing"
> > 
> > Hi Paul,
> > 
> > Just for the sake of it, the title of my dissertation is, more
> > precisely:
> > 
> >  +, title  = "Low-Impact Operating System Tracing"
> 
> Oops!!!  Good eyes!  It took me a bit to spot the difference.
> 
> I have updated my .bib file, regenerated a PDF or two, and have a
> patch in my local git tree that I will send off with the next batch.
> 
> > The final version is available at:
> > 
> > http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12-v24.pdf
> 
> Added this as well, thank you!
> 
> > (and yes, it is in English) ;-)
> 
> Most of it, anyway.  ;-)
> 
> Though it does look like you have English translations of all the French
> pieces.  I guess I won't need to run it through translate.google.com
> after all.

Or we can put it the other way around: I have a French tranlation of the
most important English pieces. ;)

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 
> > Thanks,
> > 
> > Mathieu
> > 
> > > +, author = "Mathieu Desnoyers"
> > > +, school = "Ecole Polytechnique de Montr\'{e}al"
> > > +, month  = "December"
> > > +, year   = 2009
> > > +}
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
