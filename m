Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZG0Wmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZG0Wmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZG0Wmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:42:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52507 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419AbZG0Wmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:42:44 -0400
X-Sasl-enc: creWLDqDl+z4PNGRJDBritEaStFLKo8jK2Cs1QJ4pJ4W 1248734564
Date: Mon, 27 Jul 2009 19:42:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tobias Diedrich <ranma@tdiedrich.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13826] thinkpad boots with backlight low
Message-ID: <20090727224240.GA6932@khazad-dum.debian.net>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
 <3zAHs5O6maO.A.KtC.THObKB@chimera>
 <20090727110651.GA4496@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727110651.GA4496@yamamaya.is-a-geek.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes, this still applies to 2.6.31-rc4.
> If I  don't add brightness_mode=2 the backlight controls don't work
> properly.

Patch ready. Will send to linux-acpi soon.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
