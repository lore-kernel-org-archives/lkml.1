Return-Path: <linux-kernel-owner+w=401wt.eu-S1767190AbXDESTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767190AbXDESTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767192AbXDESTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:19:17 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:47175 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767190AbXDESTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:19:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QCCTUvzDFbwin9GR0cH5q/nXZCWi5QwOBKtOXr97WR+GWGFCvJP7xiJTR9vKtVKpYAexKEah8NJ0lFzMmvc5vHfJJqbTTrf6dvAOjgqXougXrwau2TFgX8cebb+/aSwAy9SxWxLqVmiXqvssNmol7YKcOZBK9DsyV0xfVdsuZPY=  ;
X-YMail-OSG: ihyN86oVM1nlnFE7w0nuFtb.7zyRlPTLGtatifdAd7fN.TTdAGvftIyHGvJfg5UqUB77.Lfvbw--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Date: Thu, 5 Apr 2007 11:19:11 -0700
User-Agent: KMail/1.7.1
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
References: <11757099691323-git-send-email-tony@atomide.com> <Pine.LNX.4.61.0704050359320.22282@yvahk01.tjqt.qr> <46147888.2080507@oracle.com>
In-Reply-To: <46147888.2080507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051119.11944.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 9:18 pm, Randy Dunlap wrote:

> I don't think it's a MUA thing.  I think David is talking about the
> spaces after the ^\t that are used for indenting immediately under
> the "if".

Exactly.

	if (There was a young lady named Bright
		Whose speed was far faster than light) {
		She set out one day
		in a relative way
	}
	And returned on the previous night

obeys the only-ident-by-tabs rule, as does

	if (To control chain reactions, your odds
			Improve if you've got cadmium rods) {
		In your fission reactor
		Their lack is a factor
	}
	In screams of "A meltdown! Ye gods!"

Now, the former makes it hard to tell what's condition vs consequent.
(Or whatever the correct technical term is in cases like these.)

- Dave


