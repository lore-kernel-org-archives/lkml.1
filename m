Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbXBGS06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbXBGS06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXBGS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:26:58 -0500
Received: from web38511.mail.mud.yahoo.com ([209.191.125.57]:42716 "HELO
	web38511.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965707AbXBGS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:26:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WStDIWAeEgrkQOsbuI24lWMB+RCumCd4zOh4eXcKwQnNbdtN07chDsg1npn7dPQvrJPlLN4Gl6DZEV1638azglT9skd16cJ2KUMjP+12zAKis+uWg6glzHYyMjZsA8YRh7vCq0zXIoAWzl+u+uH+c/DxlvY6053dvDuJUa6L36g=;
X-YMail-OSG: kAEagU4VM1kymiQm1AAz8LOjGusrwterbG.xbi0D
Date: Wed, 7 Feb 2007 10:26:56 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: [PATCH] [NETDEV] [000]  dmfe : fix bugs and add features
To: linux-kernel@vger.kernel.org
Cc: tori@unhappy.mine.nu, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <96797.60132.qm@web38511.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Before some time I decided to fix suspend/resume on my Davicom network card.
During development I also fixed couple of bugs and added support for link detection and WOL
Note : 2.6.20 already has support for link detection , but it is broken when card has external PHY
, like mine.

So here it goes:

[PATCH] [NET] [001] dmfe : trivial/spelling fixes
[PATCH] [NET] [002] dmfe : Fix possible oops
[PATCH] [NET] [003] dmfe : fix link detection
[PATCH] [NET] [004] dmfe : Add suspend/resume support
[PATCH] [NET] [005] dmfe : Add support for wake-on-lan

        Maxim Levitsky


 
____________________________________________________________________________________
Finding fabulous fares is fun.  
Let Yahoo! FareChase search your favorite travel sites to find flight and hotel bargains.
http://farechase.yahoo.com/promo-generic-14795097
