Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYJONXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYJONXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYJONXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:23:00 -0400
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:34982 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753795AbYJONW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:22:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 09:22:58 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2JX2uKJXY/14C9H10M1UlUTNAKb2oqrnHcvFHTYK6C2M2hmC/Ii7gHZfvDrcoWIxu/OQapic+r9r42Zua5q0JcV1Y+DbYEe2wamnmNgB6QdIicV0m7/ywvCnl3Xz2vHpMr4HI7Ae0HU8wGarru7R31I7dUZI8uo2jEPygGkCaIU=;
X-YMail-OSG: XfsV28YVM1mCt5dsC0B2T.R3EYxGa3wNgo1oY8F2.1IYno7ClhQUHVnBJTtDuYp8xVC6tg6TbJXz4br1KBz.qniUBuTrYYhM2Mx49iQZBSHwZxHDjl6b1c4xv67o32ZMkg8ALMIEu8TatixSbKyt.7VAteWNBdZsAnKlx7w-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Wed, 15 Oct 2008 06:16:15 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: pommnitz@yahoo.com
Subject: Re: New Regulatory Domain Api.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <268144.25938.qm@web51404.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I always had some problems with the idea that the same regulatory settings apply to all cards in a system. This is certainly not true for the systems we ship: our system has two WLAN cards where one card is attached to an amplifier under special regulatory permission. This special permission is very strict and limits the use of the card to certain channels that are even outside the range normally used for 802.11. 

For CRDA to be useful to us we would need a way to limit one card to the common requirements for WLAN in the current environment and the other card to the special rules we got from our regulator.

-- 
Regards
       Joerg


      
