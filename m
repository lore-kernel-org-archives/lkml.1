Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbZHHISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbZHHISA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 04:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZHHIR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 04:17:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60947 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZHHIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 04:17:58 -0400
From: Martin Rogge <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
Date: Sat, 8 Aug 2009 10:19:14 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.30.4; KDE/4.2.1; i686; ; )
Cc: devzero@web.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081019.15007.marogge@onlinehome.de>
X-Provags-ID: V01U2FsdGVkX1+LM1YapJRjqotfF2kDTmoLM7/3j6eLlJLJ4oN
 T2rW3igmsHL/JuHxMKoKqqmKHAgsLwacMqfk/IV+7mqUr7IZk3
 osuKrpe+q0QQ4RXzUzopA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> 

Roland, you seem to reply to a mix of different mails. I skip the comments 
unrelated to my error report. Btw, since then there have been two more reports 
on lkml of dual P2 systems locking up with 2.6.30++.

> afaik, you can also bisect on a different (i.e. faster) box.

Since we are talking about dual-P3, no you can't.

> i think it would be more interesting if there is anything in dmesg on such

I posted dmesg etc. yesterday

> lockup. if not, maybe you can hook up a serial console or netconsole and
> trigger sysrq when you have another lockup.

Network, sysrq and numlock are all unresponsive. Like it says in the Haiku:

A crash reduces
Your expensive computer
To a simple stone.

> 
> regards
> roland

Martin

