Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZIVM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZIVM6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZIVM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:58:37 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33223 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756366AbZIVM6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:58:36 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2009 08:58:36 EDT
Message-ID: <4AB8BBEF.2040604@evidence.eu.com>
Date: Tue, 22 Sep 2009 13:58:39 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Raistlin <raistlin@linux.it>, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
References: <1253615424.20345.76.camel@Palantir>
In-Reply-To: <1253615424.20345.76.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This implementation is part of a FP7 European project called ACTORS,
> and financially supported by the European commission
> (see http://www.actors-project.eu).
> 
> The involved partners (which include Ericsson Research, Evidence Srl,
> AKAtech) strongly believe that a general-purpose operating system like
> Linux should provide a standard real-time scheduling policy (like the
> one implemented in this patch) still allowing to schedule non-real-time
> tasks in the usual way.

Hi Peter, hi all,

      note that the request of having an EDF scheduling class integrated 
in the mainline kernel does not come from academy, but comes from industry.

In particular, at least the following companies are interested in this 
feature:

1. ERICSSON AB (http://www.ericsson.com)

2. Evidence Srl (http://www.evidence.eu.com): who implemented the code

3. AKAtech (http://www.akatech.ch)

4. Qprel (http://www.qprel.com)

5. Tertium technology (http://www.tertiumtechnology.com)

6. M2Tech (http://www.m2tech.biz)


Then, there are _also_ some universities and research centers:

1. Scuola Sant'Anna, Italy

2. University of Pisa, Italy

3. Lunds Universitet, Lund, Sweden

4. Technical University Kaiserslautern, Germany

5. Ecole Polytechnique Federale de Lausanne, Swiss

But I guess there are other companies and institutions interested, out 
there...

Cheers,

            Claudio
