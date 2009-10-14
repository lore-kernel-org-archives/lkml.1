Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbZJNOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbZJNOAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZJNOAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:00:37 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:37462 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbZJNOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:00:36 -0400
Message-ID: <4AD5D943.9020507@gnumonks.org>
Date: Wed, 14 Oct 2009 15:59:31 +0200
From: Harald Welte <laforge@gnumonks.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Corentin Chary <corentin.chary@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: VT6421 problems with sata_via (VIA data sheets)
References: <71cd59b00910110254q2e5318cfw30ac0a4f86770487@mail.gmail.com> <20091011141638.616084c0@lxorguk.ukuu.org.uk>
In-Reply-To: <20091011141638.616084c0@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.8 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:

>> I recently needed some more space and bought a Deskstar 7K1000.B for my server.
>> The motherboard is old, and did not have SATA port, so I added a
>> VT6421 PCI SATA controller.
> 
> Lots of 6421 setups do not work on Linux full stop. I've asked VIA
> several times for the relevant data sheet/info to fix this and they've
> never done more than acknowledge receipt of the mail.

Whom did you e-mail?

The document is available from
ftp://ftp.vtbridge.org/Docs/Storage/DS_VT6421A_100_CCPL.PDF
for almost one year now.

If you requested it, maybe it was put there but somebody just forgot to
send follow-up mail to you.

To anyone working on Linux or other Free Software regarding VIA
hardware:  If you need documentation, or if you have any other issues,
please contact me.  I am the Liaison and I can talk with various people
and departments inside VIA.

There are some things where VIA has no documentation, and there are
other parts like video acceleration where documentation cannot be
published due to 3rd party patents and patent licensing schemes.

But for general hardware like storage controller, north/southbridge,
audio codecs, ... the documentation is possible to be released without NDA.

--
  Harald Welte <laforge@gnumonks.org>
