Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZG0LHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZG0LHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZG0LHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:07:11 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:47224 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZG0LHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:07:10 -0400
Date: Mon, 27 Jul 2009 13:06:51 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13826] thinkpad boots with backlight low
Message-ID: <20090727110651.GA4496@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pavel Machek <pavel@ucw.cz>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.KtC.THObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.KtC.THObKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).

Yes, this still applies to 2.6.31-rc4.
If I  don't add brightness_mode=2 the backlight controls don't work
properly.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13826
> Subject		: thinkpad boots with backlight low
> Submitter	: Pavel Machek <pavel@ucw.cz>
> Date		: 2009-07-15 15:13 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=124756359126830&w=4
> Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
