Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbXLDPDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbXLDPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXLDPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:03:23 -0500
Received: from ns1.primeinteractive.net ([195.95.205.253]:45376 "EHLO
	mail.primeinteractive.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbXLDPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:03:23 -0500
X-Quarantine-ID: <LkpaZ6f9o0xB>
From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Organization: Prime Interactive Ltd.
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: ICH9 & Core2 Duo - kernel crash
Date: Tue, 4 Dec 2007 16:03:16 +0100
User-Agent: KMail/1.9.7
References: <200712041331.24678.pavol.cvengros@primeinteractive.net> <20071204065232.2376f90b@laptopd505.fenrus.org>
In-Reply-To: <20071204065232.2376f90b@laptopd505.fenrus.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041603.17066.pavol.cvengros@primeinteractive.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2007 15:52:32 you wrote:
> On Tue, 4 Dec 2007 13:31:24 +0100
>
> Pavol Cvengros <pavol.cvengros@primeinteractive.net> wrote:
> > Hello,
> >
> > I am trying LKML to get some help on one linux kernel related problem.
> > Lately we got a machine with new HW from Intel. CPU is Intel Core2
> > Duo E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33
> > chipset.
> >
> > After long fight with kernel crashes on different things, we figured
> > out that if the multicore is disabled in bios, everything is ok and
> > machine is running good. No kernel crashes no problems, but with one
> > core only.
>
> to be honest, this looks like a thermal issue
> are all your fans running?
> is there anything in the case blocking air flow?

tested.... everything is ok, CPU temp - ok... ventilators ok

-- 
-----------[ Signature ]---------
Name: Pavol Cvengros
Company: Prime Interactive, Ltd.
E-mail: pavol.cvengros@primeinteractive.net
Web: http://www.primeinteractive.net
Personal web: http://orpheus.grass.sk
