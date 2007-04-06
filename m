Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXDFWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXDFWki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXDFWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:40:38 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:37278 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933265AbXDFWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:40:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Hdnvp1k/rVl6SSHu+u0kMaUcLxS5/vEdRxzt8Tlpok0HAV9FWQCNQXM2JwnsoDTUmYtjE71uHws6GD2T5GMZ9O1ra4PnwbZuYmVKRkEXkpYV4lM5FXrbx4wdFTQSLigiaNpobMqBjwVIryFUTLV2jeEHdfh7jd/i5b5RJTwOLoo=  ;
X-YMail-OSG: 6d1LbrgVM1mr67CgPG8c4ZfhqxGTBepZlP_pJjt8arzzjqPoIRZCJd_.ImqnBc1Ob0J8vlS6Qw--
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 15:40:34 -0700
User-Agent: KMail/1.7.1
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061357.03700.david-b@pacbell.net> <Pine.LNX.4.61.0704062354530.6042@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704062354530.6042@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061540.34500.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 3:04 pm, Jan Engelhardt wrote:

> >	if (...) {
> >		THAT WAS ONE MORE TAB
> >	}
> >
> >and
> >
> >	for (...) {
> >		THAT WAS ALSO ONE MORE TAB
> >	}
> >
> >Come on, stop wasting everyone's time with utter nonsense.
> 
> I was never debating these two things. 

Actually, you did.  Go back and see the point I was specifically
disagreeing with.  It related to the body of the "if" block,
which you had said would **NOT** indent by a single tab.
