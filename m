Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbXHGTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbXHGTUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXHGTUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:20:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:53187 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbXHGTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:20:46 -0400
To: "Nathan Williams" <ngwilliams@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
	<MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
	<b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 07 Aug 2007 21:20:44 +0200
In-Reply-To: <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com> (Nathan Williams's message of "Tue, 7 Aug 2007 13:29:46 +1000")
Message-ID: <m3k5s75eyb.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Nathan Williams" <ngwilliams@gmail.com> writes:

> The binary blob is run in the kernel.  I wasn't aware of any
> completely open-source drivers for ADSL modems, mine is a PCI ADSL
> modem.

People around here use Alcatel/Thomson "Speedtouch" and Sagem
"Fast" USB ADSLs. Linux has open-source drivers for both.
USB seems like an advantage in this case, too - you can connect
to any machine including non-PCI small network storage servers
with non-x86 CPU.

Hopefully you have a x86-64 version of the library as well.


You may want to check video cards stories, it seems either your
device is useful and it _will_ be reverse engineered and
eventually a open-source driver will be written, or your device
isn't useful and nobody will bother.

I both cases open-source from start is a clear win.
-- 
Krzysztof Halasa
