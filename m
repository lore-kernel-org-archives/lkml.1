Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYDAQUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYDAQUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYDAQTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:19:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:56328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYDAQTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:19:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,588,1199692800"; 
   d="scan'208";a="543681202"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [question] utrace user api / branch trace support
Date: Tue, 1 Apr 2008 17:20:07 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF5544401A80C36@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401A0699D@swsmsx413.ger.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [question] utrace user api / branch trace support
Thread-Index: AciP8d0SfJPyfMz8TEG79gjbKBU6/QAAECJAADmREzAAzvDKYA==
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com> <20080327095803.GB15003@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5B78@swsmsx413.ger.corp.intel.com> <029E5BE7F699594398CA44E3DDF5544401A0699D@swsmsx413.ger.corp.intel.com>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, <roland@redhat.com>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 01 Apr 2008 16:18:50.0307 (UTC) FILETIME=[120BA930:01C89414]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Metzger, Markus T 
>Sent: Freitag, 28. März 2008 14:45
>To: 'Ingo Molnar'; 'roland@redhat.com'

Resend...


>Ingo, Roland,
>
>I started looking into utrace. I found something at 
>.../git/frob/utrace.git.
>
>
>When I google for utrace, I find articles at lwn.net. One of 
>them (http://lwn.net/Articles/224772/) says "The core utrace 
>code does not interface with user space at all; instead, it is 
>an in-kernel API ....".
>
>That same article further says "Utrace replaces ptrace() 
>entirely, while maintaining the same interface to user space".
>
>
>I fail to understand the relation to Roland's comments that he 
>does not want further ptrace user API extensions. 
>
>Maybe these articles are outdated and there is meanwhile a 
>utrace user API. Would you please point me to some 
>documentation on how application debuggers will use utrace?
>
>
>thanks and regards,
>markus.
>
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

