Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZE1NPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZE1NPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZE1NPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:15:43 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43579 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082AbZE1NPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:15:43 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905281315.n4SDFOeE004139@mercury.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: benny+usenet@amorsen.dk (Benny Amorsen)
Date: Thu, 28 May 2009 22:45:24 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       romieu@fr.zoreil.com (Francois Romieu),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <1243500034.25386.5.camel@ursa.amorsen.dk> from "Benny Amorsen" at May 28, 2009 10:40:34 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I interprete your comment to mean that duplex can't
> > be controlled like this and it requires autonegotiation in order to active
> > full duplex mode.  If that's the case then so be it - I'm only reporting
> > what I did and what effect it had on the card.
> 
> No, you're reporting which effect it had on the SWITCH. The switch
> detected that autonegotiation failed, so it picked half duplex mode.
> Card full duplex, switch half duplex, recipe for disaster.

<shrug> I'm reporting what I could observe.  Whether that's the card, the
switch or the combination of both is for others more knowledgable in these
matters to determine.

So, all this aside, were the previously reported results useful for the
purposes they were requested for?  Or do I need to run additional tests?  If
so, what tests, exactly (since I'm not sure exactly what it is we are aiming
to test here)?

> I can recommend man ethtool.

Yes, if time allowed I would have gone through it earlier.  When I get some
spare time I'll check it out.

Regards
  jonathan
