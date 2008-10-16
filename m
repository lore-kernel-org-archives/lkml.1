Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYJPIek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYJPIek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 04:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYJPIec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 04:34:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:12003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYJPIeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 04:34:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,422,1220252400"; 
   d="scan'208";a="452016846"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: Is Debug Store supposed to default to Y?
Date: Thu, 16 Oct 2008 09:34:26 +0100
Message-ID: <029E5BE7F699594398CA44E3DDF554440290A9AA@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200810161021.25572.elendil@planet.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Is Debug Store supposed to default to Y?
Thread-Index: AckvaDF2VkYK6C/hQlWLtT/PcLqRPgAAJVDg
References: <200810161021.25572.elendil@planet.nl>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Frans Pop" <elendil@planet.nl>, <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>
X-OriginalArrivalTime: 16 Oct 2008 08:34:29.0795 (UTC) FILETIME=[01AD6730:01C92F6A]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Frans Pop [mailto:elendil@planet.nl] 
>Sent: Donnerstag, 16. Oktober 2008 10:21


>Both CONFIG_X86_DS and X86_PTRACE_BTS currently default to yes.
>Is that intended?
>
>The help text is a bit short on info to help users determine if they 
>really need/want these options. What will I be missing if I 
>don't enable 
>them on a regular desktop system? What is their cost?

I sent an rfc for an improved help text yesterday:
http://lkml.org/lkml/2008/10/15/192.
I hope this answeres your questions.

See also the discussion with Roland Dreier on the same topic:
http://lkml.org/lkml/2008/10/16/56
http://lkml.org/lkml/2008/10/16/61

regards,
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

