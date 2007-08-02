Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXHBMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXHBMHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXHBMG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:06:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49537 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbXHBMG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:06:56 -0400
Date: Thu, 2 Aug 2007 14:06:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <200708021200.l72C0Vbx008657@wildsau.enemy.org>
Message-ID: <Pine.LNX.4.64.0708021403560.24572@fbirervta.pbzchgretzou.qr>
References: <200708021200.l72C0Vbx008657@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 14:00, Herbert Rosmanith wrote:
>> Wait, you forget that something may change the name. That dmesg message
>> from 1 second ago does not need to be valid anymore, just as anything
>> else in this world.
>
>there are many things in this world which are usually very persistent, and
>people rely on their persistence. e.g. in my office, I assume the phone number
>is still the same I used 1 second ago ... but what has this to do with
>ethernet device names? well: I expected the names persist - like they did
>without udev. I'm used that things persist, as probably the rest of the world
>:-)

Yes, your telephone number persists even if you plug it into another
jack (well, at least for my ISDN box, this holds true). Your names
did persist - no card uses eth0 (which seems to belong to another one
that is not currently installed). Note also that not the names per se
are persistent, the (name,device) tuples are.


	Jan
-- 
