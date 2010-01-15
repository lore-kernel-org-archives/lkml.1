Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0AOCb0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910Ab0AOCb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:31:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60776 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0AOCbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:31:25 -0500
Date: Thu, 14 Jan 2010 18:30:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: 1Q2010 update for RCU
	documentation
Message-ID: <20100115023029.GG9077@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100115020131.GA20934@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115020131.GA20934@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 09:01:31PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > Add expedited functions.  Review documentation and update obsolete
> > verbiage.  Also fix the advice for the RCU CPU-stall kernel configuration
> > parameter, and document RCU CPU-stall warnings.
> > ---
> [...]
> > +
> > +@phdthesis{MathieuDesnoyersPhD
> > +, title  = "Low-impact Operating System Tracing"
> 
> Hi Paul,
> 
> Just for the sake of it, the title of my dissertation is, more
> precisely:
> 
>  +, title  = "Low-Impact Operating System Tracing"

Oops!!!  Good eyes!  It took me a bit to spot the difference.

I have updated my .bib file, regenerated a PDF or two, and have a
patch in my local git tree that I will send off with the next batch.

> The final version is available at:
> 
> http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12-v24.pdf

Added this as well, thank you!

> (and yes, it is in English) ;-)

Most of it, anyway.  ;-)

Though it does look like you have English translations of all the French
pieces.  I guess I won't need to run it through translate.google.com
after all.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > +, author = "Mathieu Desnoyers"
> > +, school = "Ecole Polytechnique de Montr\'{e}al"
> > +, month  = "December"
> > +, year   = 2009
> > +}
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
