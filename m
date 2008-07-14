Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYGNKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYGNKu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYGNKuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:50:19 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:52963 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbYGNKuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:50:18 -0400
From: Marc Zyngier <maz@misterjones.org>
To: "Amit Walambe" <amit.walambe@eurotech-ltd.co.uk>
Cc: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH][RFC][#2] Arcom Viper support for 2.6.26
Organization: Metropolis -- Nowhere
References: <wrpr69wq491.fsf@hina.wild-wind.fr.eu.org>
	<20080714112233.35577286@eurotech-ltd.co.uk>
X-Attribution: maz
Reply-to: maz@misterjones.org
Date: Mon, 14 Jul 2008 12:50:15 +0200
Message-ID: <wrplk04pwns.fsf@hina.wild-wind.fr.eu.org>
In-Reply-To: <20080714112233.35577286@eurotech-ltd.co.uk> (Amit Walambe's
	message of "Mon, 14 Jul 2008 11:22:33 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.70.139
X-SA-Exim-Rcpt-To: amit.walambe@eurotech-ltd.co.uk, linux-kernel@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Amit" == Amit Walambe <amit.walambe@eurotech-ltd.co.uk> writes:

Hi Amit,

Amit> Please note that Arcom is now part of Eurotech group and has changed
Amit> name to Eurotech (Ltd./Inc.). This is the updated link for the
Amit> product : http://www.eurotech.com/EN/products.aspx?pg=VIPER&pc=357

I'll make sure I'll use the updated link next time I mention the
board.

Amit> 2. If it is ok to merge the support but requires our review and
Amit> testing, I would try my best to put some time into it
Amit> ASAP. Though I must admit we might have bandwidth issues keeping
Amit> up with the mainline. But Marc, I assume, is stepping up for
Amit> this part.

I definitly am.

Even if the Viper board is old stuff these days, I think being able to
use a mainline kernel is a real bonus for people who already own this
system. Think about being able to use current distributions (I use
Debian/armel on mine).

Anyway, I'll be glad to assume the maintenance of this board, should a
version of this patch enter mainline.

Best regards,

	M.
-- 
And if you don't know where you're going, any road will take you there...
