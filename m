Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXGDCtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXGDCtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 22:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXGDCtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 22:49:07 -0400
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:24208 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754294AbXGDCtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 22:49:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XEh1abzQIRc/KX14ypjsMYN8Dmbe8hFezXIrfOnWfk1WQkbA7ZXev4K2TSmRzFMYXc3jh3j/e46emQy24/cs/GVOcK7x7JIhaPzunMn/Al7v5v7s4Wlj3gngo9Hho9lLQPotikYx29Fq23rF7ogLlkNzubDM5zdl6x8Hiw4SCyk=;
X-YMail-OSG: GLckCGQVM1nzDqCwCdHby5tNXHtc72x5.GwHDgPWFm3iQFuZra5jSSHw3HKe0dRUQYipRszKHF.l8PJ84VOnOVbIJNhqKJa0KkAKqVPkU.E7lo8bZNJGoxNTugOLsw--
Date: Tue, 3 Jul 2007 19:49:05 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [tifm] Infinite loop
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <468AD29F.6040908@mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <382082.2193.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Renato S. Yamane" <renatoyamane@mandic.com.br> wrote:

> When I insert a SDCard in my laptop M45-S355 my system crash because 
> tifm start a infinite loop. See below more detail about SD/MMC Card and 
> infinite loop.

If you are using the built-in version found in 2.6.21 then it is a known problem. You can use the
driver from here, to fix this:
https://developer.berlios.de/project/showfiles.php?group_id=5510

(or wait for 2.6.22)



      ____________________________________________________________________________________
Luggage? GPS? Comic books? 
Check out fitting gifts for grads at Yahoo! Search
http://search.yahoo.com/search?fr=oni_on_mail&p=graduation+gifts&cs=bz
