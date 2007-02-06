Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbXBFRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbXBFRT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXBFRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:19:28 -0500
Received: from web38507.mail.mud.yahoo.com ([209.191.125.53]:43506 "HELO
	web38507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751651AbXBFRT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:19:27 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 12:19:27 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FOilkRvlL0BpHWo3jvgH8Ayv8eFw1c6M1bOPkYVFZoRFvmEtz2RSCaorx9jrLref1eG/QsFnV/A6d8MbtYAsk/XTmcW1wEM3g8MnxMhybJkrZ0LX5h5FpL1fLFRzG6/eXxMqGm5bwEzJVJeDBlU/CAENdikgZ1AYLVlOXNbJrww=;
X-YMail-OSG: ZFVL4VgVM1mgvJgYrTln7gAJkguwkentRByzPPj_8AQG4BL6JwPf6wsJ_UWi.To_wQ--
Date: Tue, 6 Feb 2007 09:12:47 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Question: Status of marvell's PATA 88SE6101 controller on intel boards
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <508716.76088.qm@web38507.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am going to buy a intel DG965RYCK motherboard. The board looks ok to me , 
but I found that it contains marvell's 88SE6101 PATA controller , and I need to use PATA.

I also noticed that 2.6.20 adds experimentally support for that chip.
But driver says that it enables it via 'legacy mode'

I will be glad to hear whenever full support is planned or not.

And as last thing I want to ask you whenever current support is usable, 
that is can I use DMA , can I use DVD as at least reader for CD/DVD , 
and even better can I burn disks with it ( although I can live without it)

Your truly,
             Maxim Levitsky


Maxim Levitsky


 
____________________________________________________________________________________
Don't get soaked.  Take a quick peak at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
