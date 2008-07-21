Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYGUPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYGUPfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbYGUPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:35:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:43525 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGUPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=h8UhmTCiH6jZx8z0HrQXWT2qdAJmhgZojeFhVf9/1RSQyvCdOrUAg1M3c+ERGQ1fwz
         tpFoQTwqfuFuCTWin7itdszV8Lk8nKWtmiShoNh1yGm97oi29bsaDHHHxg2fy1Y2mtw3
         YYmCziOeOGJzjsRBSAXBSd9LPrGVJJs25NG5c=
Message-ID: <4884ACA6.9080509@gmail.com>
Date: Tue, 22 Jul 2008 00:35:02 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com>	<20080719033050.552f9b49@mjolnir.drzeus.cx>	<48814D81.8060001@gmail.com>	<20080719140717.7b296eae@mjolnir.drzeus.cx>	<4881F437.7000503@gmail.com>	<20080721004033.1fc66aa3@mjolnir.drzeus.cx>	<4883DA8C.5030306@gmail.com> <20080721133209.62e31bc8@mjolnir.drzeus.cx>
In-Reply-To: <20080721133209.62e31bc8@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Mon, 21 Jul 2008 09:38:36 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> I think it needs an ACK from Jens.  Jens?
> 
> He seems to be on vacation. I sent him a review request for my original
> code a couple of weeks ago, and I haven't heard anything. marc.info
> also doesn't show anything since the 3rd. Odds are he won't be back
> during the merge window. :/

Right, I have a patchset waiting for his review too.  Anyone knows when
he'll be back?

We can always back it out later but I don't think pushing stuff in w/o
maintainer's ack is a good idea.  :-(

-- 
tejun
