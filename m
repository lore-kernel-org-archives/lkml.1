Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0AOCBf (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556Ab0AOCBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:01:34 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:33819 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0AOCBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:01:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE5VT0uuWOiG/2dsb2JhbACBRNZ0hDAEgx4
Date: Thu, 14 Jan 2010 21:01:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: 1Q2010 update for RCU
	documentation
Message-ID: <20100115020131.GA20934@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:18:39 up 29 days,  9:37,  5 users,  load average: 0.26, 0.10,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Add expedited functions.  Review documentation and update obsolete
> verbiage.  Also fix the advice for the RCU CPU-stall kernel configuration
> parameter, and document RCU CPU-stall warnings.
> ---
[...]
> +
> +@phdthesis{MathieuDesnoyersPhD
> +, title  = "Low-impact Operating System Tracing"

Hi Paul,

Just for the sake of it, the title of my dissertation is, more
precisely:

 +, title  = "Low-Impact Operating System Tracing"

The final version is available at:

http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12-v24.pdf

(and yes, it is in English) ;-)

Thanks,

Mathieu

> +, author = "Mathieu Desnoyers"
> +, school = "Ecole Polytechnique de Montr\'{e}al"
> +, month  = "December"
> +, year   = 2009
> +}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
