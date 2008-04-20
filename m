Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYDTWEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYDTWEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYDTWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:04:26 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:33958 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751166AbYDTWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:04:21 -0400
X-YMail-OSG: He2VJg4VM1kSm_.1srLVx1C9m1jo4znZzryYfo1keeg7VFt.jszrs2uw1F_xdpxrdw--
X-RocketYMMF: rancidfat
Date: Sun, 20 Apr 2008 15:04:20 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: 2.6.25 Kernel - Problems with capabilities
To: Andi Kleen <andi@firstfloor.org>, David <david@unsolicited.net>
Cc: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <87y7788hul.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <898767.43890.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:

> David <david@unsolicited.net> writes:
> 
> > Casey Schaufler wrote:
> >> Do you have a libcap that reflects the change from 32 capabilities
> >> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
> >>
> > Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm
> > now running normally, thanks!
> 
> FWIW I ran into this problem too with systemtap. It was a quite 
> nasty surprise and took some time to track down.
> 
> I also don't remember seeing a thread about this on l-k.  Where was this
> major binary breakage discussed?

lkml and lsm.


Casey Schaufler
casey@schaufler-ca.com
