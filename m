Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbYHXRCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbYHXRCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYHXRCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:02:39 -0400
Received: from ikar.perftech.si ([195.246.0.20]:6765 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYHXRCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:02:38 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Aug 2008 13:02:38 EDT
X-ASG-Debug-ID: 1219596266-30fb00020000-WJxGKN
X-ASG-Debug-ID: 1219596266-30fb00020000-WJxGKN
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Spam-Processed: dedal.perftech.si, Sun, 24 Aug 2008 18:44:25 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: xerces8@butn.net
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
Date: Sun, 24 Aug 2008 18:44:24 +0200
From: "xerces8" <xerces8@butn.net>
To: "Sergey Spiridonov" <sena@hurd.homeunix.org>, linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363 
	(JMB363) kernel 2.6.25-2 Debian/Lenny
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363 
	(JMB363) kernel 2.6.25-2 Debian/Lenny
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WorldClient-F200808241844.AA44240046@butn.net>
X-Mailer: WorldClient 9.6.4
In-Reply-To: <g8q9mg$v2p$1@ger.gmane.org>
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org>
X-MDAV-Processed: dedal.perftech.si, Sun, 24 Aug 2008 18:44:26 +0200
X-Barracuda-Connect: UNKNOWN[10.12.0.44]
X-Barracuda-Start-Time: 1219596266
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.1.3594
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Spiridonov wrote:

> Jeff Garzik wrote:
> 
> > So...  suspect bad cables, bad port connectors, cable interference,
> > motherboard-caused interference or grounding problems, power supply
> > problems.
> 
> I did exchange power supply and I did exchange hard drives. The same
> hard drive with the same cable works with SB600 and produces errors with
> JMB363. So looks like it is not cable or hard drive problem. May be the
> problem is JMB363 port connector on the motherboard. How can I check it?

Hi!

I have a JMB363 myself and it has its share of problems.
I would say it is buggy hardware. (why would they otherwise
release a new windows driver every week ? if not to workaround
bugs in HW ;-)

My WD MyBook Studio Edition 500 GB external eSATA drive does not
work on the JMB363 correctly no matter what I try. Both
under linux and windows. I think the best was 30 minutes of
(apparent) error free operation under windows.

If interested, I can supply logs, data etc.
(I have a bunch of drives to try).

Regards,
David


