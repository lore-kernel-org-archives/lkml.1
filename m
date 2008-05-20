Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbYETLRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbYETLRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYETLRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:17:39 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:38069 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYETLRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:17:38 -0400
Date: Tue, 20 May 2008 13:17:01 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080520111700.GE5025@ics.muni.cz>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.OcB.itBMIB@albercik> <200805201258.00376.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805201258.00376.oliver@neukum.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 May 2008 13:17:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 12:57:59PM +0200, Oliver Neukum wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> Can you please also post your .config with which this problem happens?

done.
http://bugzilla.kernel.org/show_bug.cgi?id=10630

-- 
Luká¹ Hejtmánek
