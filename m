Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXHTBsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXHTBsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXHTBsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:48:24 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:26615 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751663AbXHTBsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NeF9uFiOnkEQAjIw8gfTijgWgSi8ImQJlS5mn9cozGFFsoBgfypToHxyyP/MoUhncZgUmC13OOhUjvP184smWXqzS+WNt57k5J9riPchKxfP/cv0iihda3qUjLuO0HYKxh41N9ZRcbjgEO/5uQvbvkvmDsc+BPKuhc1nBQ3sunY=  ;
X-YMail-OSG: rvX02rgVM1lphiB_edVS3wsTHfLQElC3F9bb.lFIW.iY0ga5tfVyhy4kmWNyw5Ug.sV6G6XFwA--
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Sun, 19 Aug 2007 18:48:20 -0700
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, greg@kroah.com
References: <200708170902.01260.david-b@pacbell.net> <20070819.215751.25908715.anemo@mba.ocn.ne.jp> <1187559950.4419.79.camel@lov.localdomain>
In-Reply-To: <1187559950.4419.79.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191848.21410.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Kay Sievers wrote:
> No, I object to the concept of "platform" to disable all uevents by
> default, 

Which it certainly doesn't do.

Since the $SUBJECT patch doesn't affect a platform driver in any case,
all those comments are well off-topic for $SUBJECT.
