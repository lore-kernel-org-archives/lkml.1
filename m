Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYHJOPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYHJOPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 10:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYHJOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 10:15:28 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:43435 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYHJOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 10:15:27 -0400
Date: Sun, 10 Aug 2008 16:15:16 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [Bug #11235] acer-wmi broken in latest git kernel on TravelMate
 6492 (Insufficient arguments - method [WQAA])
In-Reply-To: <cX_-nNkxKaF.A.ayB.jDjnIB@albercik>
Message-ID: <alpine.LNX.1.10.0808101605160.12259@titan.stealer.net>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.ayB.jDjnIB@albercik>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.7
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 10 Aug 2008 14:15:26 +0000
	Bayes: 0.0140 Tokens: new, 216; hammy, 4; neutral, 4; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.3 SARE_SUB_OBFU_Q0 FVGT - subject contains odd letter combination
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0140]
X-Spam-Signature: 873e36af8d860b318274d20a5f70dd797b453674
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

Yes.

I don't think it is included in some tree yet. Andi, care to take the 
patch into your ACPI tree?

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11235
> Subject		: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient arguments - method [WQAA])
> Submitter	: Sven Wegener <sven.wegener@stealer.net>
> Date		: 2008-08-02 15:50:54 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121769235318600&w=4
> Handled-By	: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Patch		: http://marc.info/?l=linux-kernel&m=121769591723088&w=4
