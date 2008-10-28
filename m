Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYJ1RlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYJ1RlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYJ1Rkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:40:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:60331 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbYJ1Rkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:40:55 -0400
Message-ID: <fa686aa40810281040s376557f7ucdaa4ae094611bf1@mail.gmail.com>
Date: Tue, 28 Oct 2008 11:40:54 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Cc: "Trent Piepho" <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, "Richard Purdie" <rpurdie@rpsys.net>,
       "Sean MacLennan" <smaclennan@pikatech.com>,
       "Wolfram Sang" <w.sang@pengutronix.de>
In-Reply-To: <20081028165623.GA6686@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
	 <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
	 <20081028143933.GA18453@oksana.dev.rtsoft.ru>
	 <fa686aa40810280753lc555683y5d32da678384438@mail.gmail.com>
	 <20081028151659.GA26444@oksana.dev.rtsoft.ru>
	 <fa686aa40810280842t36da3998j5f7ad22acf9f582c@mail.gmail.com>
	 <20081028165623.GA6686@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:56 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Tue, Oct 28, 2008 at 09:42:36AM -0600, Grant Likely wrote:
>> Then we coordinate with Greg and make sure the fixup gets put in place
>> before the window opens; either by bringing the patch in Ben's tree or
>> by getting Greg to pull Ben's tree into -next.  This API change should
>> not block Greg picking up the FHCI driver.  This is not an
>> insurmountable problem.
>
> Sounds complicated.
>
> Ok, but if something will go wrong with the FHCI vs. of_get_gpio()
> change, I'll just attribute the blame to you. :-))

Bring it on.  :-)

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
