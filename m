Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYHYOwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYHYOwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYHYOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:52:11 -0400
Received: from ikar.perftech.si ([195.246.0.20]:17901 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbYHYOwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:52:10 -0400
X-ASG-Debug-ID: 1219675927-2e5100130000-WJxGKN
X-ASG-Debug-ID: 1219675927-2e5100130000-WJxGKN
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Spam-Processed: dedal.perftech.si, Mon, 25 Aug 2008 16:52:07 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: xerces8@butn.net
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
Date: Mon, 25 Aug 2008 16:52:03 +0200
From: "xerces8" <xerces8@butn.net>
To: "Sergey Spiridonov" <sena@hurd.homeunix.org>, linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363 
	(JMB363) kernel 2.6.25-2 Debian/Lenny
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363 
	(JMB363) kernel 2.6.25-2 Debian/Lenny
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WorldClient-F200808251652.AA52030010@butn.net>
X-Mailer: WorldClient 9.6.4
In-Reply-To: <g8sqp1$jn4$1@ger.gmane.org>
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org> <48B0E608.4050205@garzik.org> <g8sqp1$jn4$1@ger.gmane.org>
X-MDAV-Processed: dedal.perftech.si, Mon, 25 Aug 2008 16:52:07 +0200
X-Barracuda-Connect: UNKNOWN[10.12.0.44]
X-Barracuda-Start-Time: 1219675927
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.1.3682
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Spiridonov wrote:

> Seagate
> support does not tell anything except something like "it should work"...

I just got this* link from WD support, accompanied with the text:
"This sounds like an incompatibility perhaps with the ESATA controller.
Please see the link below for tested ESATA controllers."

* - http://www.wdc.com/en/products/resources/esataupgrade.asp

Regards,
David


