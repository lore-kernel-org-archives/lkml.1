Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYCMMYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYCMMYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYCMMYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:24:10 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:38481 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYCMMYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:24:09 -0400
Date: Thu, 13 Mar 2008 13:23:44 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313122344.GD27873@ics.muni.cz>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080313120514.GH17940@kernel.dk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 13 Mar 2008 13:23:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 01:05:14PM +0100, Jens Axboe wrote:
> And lets now get back to reality - the reality that now breaks the
> previously working setup of lots of users. So you are telling me that in
> order to get my volume key functionality back I have to get rid of HAL
> and X?
> 
> Lets turn back time a bit. Why was this change made? IOW, what was the
> reason for breaking a working setup for lots of users? It better be a
> damn good reason, or I would heavily argue for reverting this change so
> that 2.6.25 actually WORKS as expected for thinkpad users.

so, you are telling that xev does not show keycodes of volume buttons for you,
right? Because for me, it works. Thinkvantage does not work.

-- 
Luká¹ Hejtmánek
