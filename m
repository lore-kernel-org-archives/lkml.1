Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYF0NLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYF0NLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYF0NL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:11:26 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:46359 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYF0NLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:11:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=fDOnHTkuHyGBfVycvSOEZ+iUb5iuDTiPgC7Z9K9w8ZYpNCNYVdfW5h8IMMKj/J9og
	m/rdyLDKZlElFvU9EbHdqBjd8PHZb7mjIJFdrnmxzE3Woqu7RG5KXh/TBNP2uxM5IoQ
	g9WDnK0IQ9ZHd6rxxTjsHB9Shd6O03G9U0DRn3I=
In-Reply-To: <alpine.LFD.1.10.0806271240461.3297@apollo.tec.linutronix.de>
Date: Fri, 27 Jun 2008 15:10:32 +0200 (CEST)
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       =?us-ascii?Q?Michal=20Simek?= <monstr@monstr.eu>
To: =?us-ascii?Q?Thomas=20Gleixner?= <tglx@linutronix.de>
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20=5BPATCH=2026=2F60=5D=20microblaze=5Fv4=3A=20time=20support?=
Mime-Version: 1.0
Message-Id: <4641.7464-1217-45420265-1214572232@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm1<166226729>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +static inline void udelay(unsigned long usec)
>> +{
>> +}
>
>shouldnt this function be named zerodelay() ?
>
>Thanks,
>	tglx

I have prepared implementation of this function which sent me JW.
I did some changes which I test it because I found problem there. 

M





