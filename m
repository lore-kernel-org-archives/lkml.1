Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYK0AUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYK0AUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYK0AT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:19:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:47183 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752365AbYK0AT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:19:57 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Thu, 27 Nov 2008 01:19:55 +0100
From: "Carsten Menke" <bootsy52@gmx.net>
In-Reply-To: <492DE30B.4080300@shaw.ca>
Message-ID: <20081127001955.5860@gmx.net>
MIME-Version: 1.0
References: <20081126231213.271070@gmx.net> <492DE30B.4080300@shaw.ca>
Subject: Re: Panic:  NMI Watchdog detected LOCKUP on CPU
To: linux-kernel@vger.kernel.org
X-Authenticated: #1189245
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18ZCTVmxocZueOFt2OoAw50H4DM10O0RGxRUgNBF0
 oMOpb3S71EzGIJ339OB75xeGnJvGLUaTKdJg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: nN8beHgxYmYBZ0sSd3c36q9CWkZTQdRB
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Wed, 26 Nov 2008 18:00:11 -0600
> Von: Robert Hancock <hancockr@shaw.ca>
> An: linux-kernel@vger.kernel.org
> Betreff: Re: Panic:  NMI Watchdog detected LOCKUP on CPU

> Normally server-class hardware doesn't cause these kinds of symptoms 
> from hardware problems, they usually spew NMIs, etc. but it's not 
> impossible. 2.6.15 is pretty ancient though. Can you try a newer kernel?
> 

Yes I will try that definitley, but I hoped that someone maybe knows if that was a particular problem of that
kernel (according to the panic log) version and chances are good they are fixed in later versions. The second problem is, that it can takes fairly long until I know if the problem is gone because sometimes it takes 2 months until a crash happens. So the second question is, how to prove if this is not hardware or how to prove it is definitley hardware. I have read the list and saw that NMI CPU Lockup messages can also be due to kernel bugs. 

Regards

Carsten
P.S. before the these problems happened the server was running well for a year, but I've also done the usual system upgrades
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
