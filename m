Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZJEShI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZJEShI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZJEShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:37:07 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:14593 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754128AbZJEShH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:37:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: futex question
Date: Mon, 5 Oct 2009 11:36:29 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501FD8772@exchange.ZeugmaSystems.local>
In-Reply-To: <4AC9FCA6.8060203@anirban.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: futex question
Thread-Index: AcpFxK5vwGfaAEvNQSOHyZBpQp0bQwAJb5Qw
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>  <1254738974.26976.24.camel@twins>  <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain> <1254741372.26976.35.camel@twins> <alpine.LFD.2.00.0910051346230.2646@localhost.localdomain> <4AC9F06B.8020708@anirban.org> <alpine.LFD.2.00.0910051525560.2646@localhost.localdomain> <4AC9FCA6.8060203@anirban.org>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Anirban Sinha" <ani@anirban.org>, "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, "Darren Hart" <dvhltc@us.ibm.com>,
       "Kaz Kylheku" <KKylheku@zeugmasystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I thought clearing the head pointers was a part of the stale existing
state?

.. and by head pointer I mean the current->robust-list pointer and it's
compat version.
