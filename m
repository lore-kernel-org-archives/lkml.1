Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYGWIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYGWIHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYGWIG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:06:56 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37836 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGWIGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:06:55 -0400
Date: Wed, 23 Jul 2008 10:06:38 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Brice Goglin <brice@myri.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
Message-ID: <20080723080638.GL4359@ics.muni.cz>
References: <20080722150438.GK4359@ics.muni.cz> <48865B04.6030707@myri.com> <488664A0.3040407@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <488664A0.3040407@myri.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 23 Jul 2008 10:06:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:52:16AM +0200, Brice Goglin wrote:
> > I have seen one machine with a similar problem. Does reverting
> > 014377a1df693ff30a9e8b69f0bbb0a38e601f75 help? Also could you check that
> > current Linus' git works fine? (just get the driver source from there,
> > no need to build the whole tree)
> >   
> 
> If the above is correct, then patch below should fix it. If so, I'll
> push this into the next stable 2.6.26.x release.

did not try to revert the mentioned patch but your attached patch made the
kernel driver working. So, please push it into the next stable.

-- 
Luká¹ Hejtmánek
