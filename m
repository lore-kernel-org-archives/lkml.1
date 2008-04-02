Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYDBDVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYDBDVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 23:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYDBDVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 23:21:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42059 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYDBDVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 23:21:39 -0400
Date: Wed, 2 Apr 2008 05:21:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix kernel thread names that might offend users.
In-Reply-To: <47F2D343.3060009@gmail.com>
Message-ID: <alpine.LNX.1.10.0804020510290.6604@fbirervta.pbzchgretzou.qr>
References: <87r6dps3db.fsf@saeurebad.de> <47F2D343.3060009@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-02 02:28, Dmitri Vorobiev wrote:
>>
>> To settle things down a bit on the bugtrackers, this patch renames all
>> offending kernel threads into something that goes better with
>> GNOME-based systems.
>> Since KDE is essentially dead[...]

Beware of Linus's strong contrary opinion! (You might get called upon.)

>> Also, please let me know if I forgot something.

Since it all seems to be an April's joke, how about the KDE
people change _their_ program names so as to

(1) not confuse kernel people [kwin -> kdewin]
     since apparently, GNOME does it more than just right
     (who would have thought! "gnome-control-center" is a perfect name,
     "gcontrolcenter" would have been acceptable too, but "gcc" would not.)

and

(2) not look like they did not know the English language.
     [kontact,kolf,kompare -> contact,golf,compare]

     Some are valid in German though [kalzium,konsole] and KDE does
     seem to have strong .de ties, so I let these go through.


> Did you forget to send this patch yesterday in which case this would have
> been more suitable for April 1st?

|Date: Tue, 01 Apr 2008 22:54:08 +0200 
|From: Johannes Weiner
|To: Linux Kernel Mailing List


-- 
make boldconfig -- to boldly select what no one has selected before
