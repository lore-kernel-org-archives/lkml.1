Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZJFKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZJFKKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbZJFKKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:10:18 -0400
Received: from mci007.btnet.de ([194.172.160.7]:36793 "EHLO relay.btnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbZJFKKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:10:18 -0400
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: AW: AW: clock_nanosleep: cyclic POSIX thread freezes during time setting
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Date: Tue, 6 Oct 2009 12:09:35 +0200
Message-ID: <40F775BBD072A346957E787B3D0DBE5F1C97B6@w2k3-46ex01.RITTER.LOCAL>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: AW: AW: clock_nanosleep: cyclic POSIX thread freezes during time setting
thread-index: AcpGbHRVVjXKNE5aQ26gPUhEDh0PVAAAK9UA
References: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910052044410.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B4@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910061112400.2646@localhost.localdomain> <40F775BBD072A346957E787B3D0DBE5F1C97B5@w2k3-46ex01.RITTER.LOCAL> <alpine.LFD.2.00.0910061201210.2646@localhost.localdomain>
From: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
To: "Thomas Gleixner" <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello Thomas,

> -----Ursprüngliche Nachricht-----
> Von: Thomas Gleixner [mailto:tglx@linutronix.de] 
> Gesendet: Dienstag, 6. Oktober 2009 12:05
> An: Mehlan, Markus
> Cc: linux-kernel@vger.kernel.org
> Betreff: Re: AW: AW: clock_nanosleep: cyclic POSIX thread 
> freezes during time setting
> 
> CONFIG_FTRACE=y is missing.
OK!
> 
> I don't remember whether the older -rt kernels had ftrace 
> support for powerpc. 
> 
> Can you verify whether later -rt versions (29-rt or 31-rt) 
> have the same problem ?
> 
> Thanks,
> 
> 	tglx
> 
I have tested with 2.6.29.6-rt23 and couldn't reproduce the problem
up to now.

Greetings,
Markus

Sitz der Gesellschaft: Oberhausen
Handelsregister Amtsgericht Duisburg HRB-Nr. 17168 UST ID-Nr. DE 814009849
Geschaftsfuehrer: Manfred A. Wagner und Dr. Uwe Baader

