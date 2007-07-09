Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbXGIQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbXGIQJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbXGIQJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:09:03 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:20528 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXGIQJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:09:01 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: clocksource tsc unstable
Date: Mon, 9 Jul 2007 18:08:44 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46924CEB.7080108@mandic.com.br> <46925970.8080602@redhat.com>
In-Reply-To: <46925970.8080602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707091808.45250.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 of July 2007, Arnaldo Carvalho de Melo wrote:
> Renato S. Yamane wrote:
> > On Kernel 2.6.21.6 I see this message in dmesg:
> > Clocksource tsc unstable (delta = 732182695 ns)
> >
> > It's normal?
>
> AMD CPU? SMP? Details, please.

Here (after resume from ram btw):
[   10.726665] Marking TSC unstable due to: possible TSC halt in C2.
[   47.203328] Clocksource tsc unstable (delta = -198170415 ns)

2.6.22 #77 Mon Jul 9 09:14:25 CEST 2007 i686

vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 2.00GHz


It's thinkpad z60m.

> - Arnaldo

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
