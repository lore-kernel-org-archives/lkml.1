Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYC1NqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYC1NqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYC1NqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:46:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:39095 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYC1NqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:46:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,570,1199692800"; 
   d="scan'208";a="541631754"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [question] utrace user api / branch trace support
Date: Fri, 28 Mar 2008 13:44:34 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401A0699D@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444019B5B78@swsmsx413.ger.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [question] utrace user api / branch trace support
Thread-Index: AciP8d0SfJPyfMz8TEG79gjbKBU6/QAAECJAADmREzA=
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com> <20080327095803.GB15003@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5B78@swsmsx413.ger.corp.intel.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, <roland@redhat.com>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 28 Mar 2008 13:43:36.0601 (UTC) FILETIME=[B8FDE890:01C890D9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Roland,

I started looking into utrace. I found something at
.../git/frob/utrace.git.


When I google for utrace, I find articles at lwn.net. One of them
(http://lwn.net/Articles/224772/) says "The core utrace code does not
interface with user space at all; instead, it is an in-kernel API ....".

That same article further says "Utrace replaces ptrace() entirely, while
maintaining the same interface to user space".


I fail to understand the relation to Roland's comments that he does not
want further ptrace user API extensions. 

Maybe these articles are outdated and there is meanwhile a utrace user
API. Would you please point me to some documentation on how application
debuggers will use utrace?


thanks and regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

