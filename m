Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYH3SNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYH3SNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYH3SNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:13:44 -0400
Received: from ikar.perftech.si ([195.246.0.20]:1371 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYH3SNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:13:43 -0400
X-ASG-Debug-ID: 1220120019-34b000000000-WJxGKN
X-ASG-Debug-ID: 1220120019-34b000000000-WJxGKN
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Spam-Processed: dedal.perftech.si, Sat, 30 Aug 2008 20:13:38 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: xerces8@butn.net
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
Date: Sat, 30 Aug 2008 20:13:36 +0200
From: "xerces8" <xerces8@butn.net>
To: "Tejun Heo" <tj@kernel.org>
CC: "Sergey Spiridonov" <sena@hurd.homeunix.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363
		(JMB363) kernel 2.6.25-2 Debian/Lenny
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363
		(JMB363) kernel 2.6.25-2 Debian/Lenny
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <WorldClient-F200808302013.AA13360018@butn.net>
X-Mailer: WorldClient 9.6.4
In-Reply-To: <48B92846.7050004@kernel.org>
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org> <WorldClient-F200808241844.AA44240046@butn.net> <48B92846.7050004@kernel.org>
X-MDAV-Processed: dedal.perftech.si, Sat, 30 Aug 2008 20:13:39 +0200
X-Barracuda-Connect: UNKNOWN[10.12.0.44]
X-Barracuda-Start-Time: 1220120020
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.1.4171
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> xerces8 wrote:
> > My WD MyBook Studio Edition 500 GB external eSATA drive does not
> > work on the JMB363 correctly no matter what I try. Both
> > under linux and windows. I think the best was 30 minutes of
> > (apparent) error free operation under windows.
> 
> This one is being discussed both with JMB and WD.  It seems the bridge
> chip used in the WD external drives is somehow incompatible with the
> JMB ahci's.  Don't know whose fault it is or how it can be worked
> around yet.  The issue is being tracked in the following bugzilla.
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=9913

I know, I'm David Balažic (the last commenter on bug, besides you) ;-)

Regards,
David


