Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZFPLrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZFPLrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZFPLrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:47:08 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55706 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZFPLrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:47:07 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH/RFC] Acer Aspire One fan control resume fix, improvements
Date: Tue, 16 Jun 2009 07:47:02 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30-crc; KDE/4.2.4; x86_64; ; )
Cc: Peter Feuerer <peter@piie.net>, akpm@linux-foundation.org,
       Andreas Mohr <andi@lisas.de>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090604211103.4214303f.peter@piie.net> <cone.1245086149.988051.6046.1000@deskpiie> <20090616060107.GA4752@liondog.tnic>
In-Reply-To: <20090616060107.GA4752@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160747.04094.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009 02:01:07 Borislav Petkov wrote:
> Hi Peter,
> 
> On Mon, Jun 15, 2009 at 07:15:49PM +0200, Peter Feuerer wrote:
> > Hi Andreas, Hi Boris,
> >
> > I just returned from my holiday trip to italy. Thank you very much for 
> > your changes. I'll merge and review them within next 2 days and send a 
> > complete patch against linus-git.
> >
> > How long is the merge window for 2.6.31 opened? Do you think we will 
> > finally get the driver merged?
> 
> the merge window opened sometime around mid last week so I think there's
> plenty of time. However, it is always a good idea if the driver sees a
> bit more testing by a wider audience, maybe linux-next.
> 
> Andrew, what do you think?

Please add this to the kernel now.  I have been using version of this on my wife's
acer since I installed linux on it.  Its been doing its job as adverstised.  This is not
a core feature - its a driver.  It works.  Why not add it?

Ed Tomlinson
