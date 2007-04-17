Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXDQPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXDQPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXDQPa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:30:59 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:39115 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752945AbXDQPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:30:57 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Message-ID: <4624E813.9000200@wizy.org>
Date: Tue, 17 Apr 2007 16:30:27 +0100
From: Ricardo Correia <linux-kernel@wizy.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Theodore Tso <tytso@mit.edu>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>	 <20070417131045.GB18373@thunk.org>	 <Pine.BSO.4.63.0704171527150.11088@rudy.mif.pg.gda.pl>	 <20070417154814.632da1d9@the-village.bc.nu>  <4624E275.7000705@wizy.org> <1176823385.14404.28.camel@frg-rhel40-em64t-04>
In-Reply-To: <1176823385.14404.28.camel@frg-rhel40-em64t-04>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
>> That is not quite true. They made ZFS available under the CDDL, which is
>> an OSI-approved open-source license that is *less* restrictive than the
>> GPL. The CDDL doesn't prevent anyone from using the ZFS code in
>> combination with code under other licenses.
> 
> You are wrong. Please read e.g.
> <http://www.gnu.org/licenses/license-list.html#GPLIncompatibleLicenses>
> (maybe there are better analysis somewhere, but I don't know where).

What I meant in saying the CDDL is less restrictive than the GPL is that
the CDDL can be freely used in conjunction with code under other
licenses, as long as the files licensed under CDDL keep the license
notice, whereas the GPL requires that derived works also have to be
licensed under the GPL, which is not possible in many cases (such as
this one).

