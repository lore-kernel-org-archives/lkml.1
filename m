Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695Ab0AYV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0AYV5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559Ab0AYV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:57:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0AYV5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:57:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #15137] NULL pointer dereference in vlan_skb_recv
Date: Mon, 25 Jan 2010 22:58:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, bonbons@linux-vserver.org,
       eric.dumazet@gmail.com
References: <hE3x9c-4KZM.A.W0E.4JMXLB@chimera> <201001252207.53023.rjw@sisk.pl> <20100125.133024.41664373.davem@davemloft.net>
In-Reply-To: <20100125.133024.41664373.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001252258.38608.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Mon, 25 Jan 2010 22:07:52 +0100
> 
> > On Monday 25 January 2010, Américo Wang wrote:
> >> On Sun, Jan 24, 2010 at 11:04:41PM +0100, Rafael J. Wysocki wrote:
> >> >This message has been generated automatically as a part of a report
> >> >of recent regressions.
> >> >
> >> >The following bug entry is on the current list of known regressions
> >> >from 2.6.32.  Please verify if it still should be listed and let me know
> >> >(either way).
> >> >
> >> >
> >> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15137
> >> >Subject		: NULL pointer dereference in vlan_skb_recv
> >> >Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> >> >Date		: 2010-01-23 15:56 (2 days old)
> >> >References	: http://marc.info/?l=linux-kernel&m=126426286507497&w=4
> >> >Handled-By	: Eric Dumazet <eric.dumazet@gmail.com>
> >> >Patch		: http://patchwork.kernel.org/patch/74999/
> >> >		  http://patchwork.kernel.org/patch/75002/
> >> >
> >> 
> >> This one can be closed, patch from Eric is already applied by David Miller.
> > 
> > Is it in the Linus' tree already?
> 
> No, but it will be there soon, I'll push it to him today.
> :-)

Thanks!
